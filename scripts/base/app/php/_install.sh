#!/bin/bash

#set -euo pipefail
# ----------------------------------------------------------------------------------------------------------------------
# Scripts - Deploy - Dev - Linux - Ubuntu - PHP - Install
# ----------------------------------------------------------------------------------------------------------------------
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # ------------------------------------------------------------------------------------------------------------------
    # PHP - Preconditions
    # ------------------------------------------------------------------------------------------------------------------
    # PHP_VERSION comes from `.env.app` and is sourced by `_project.sh` (deploy.sh runs setProject → setPhp).
    # If it is empty, almost every path in this file breaks silently — non-existent package names such as
    # `php-fpm` and malformed paths such as `/etc/php//fpm` get built, and apt/sed then act on the wrong
    # targets. Fail loudly instead.
    if [ -z "${PHP_VERSION:-}" ]; then
      echo "[ ERROR ] PHP_VERSION is empty — check .env.app"
      echo "          deploy.sh must call setPhp only after setProject (which sources .env.app)."
      setExit
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # PHP - Check Repository
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> PHP - Check Repository
    echo ">>>> PHP - Check Repository"
    echo

    APT_SW_INFO="software-properties-common"
    APT_SOFTWARE_PROPERTIES_COMMON_INFO=$(dpkg -l | grep -i "software-properties-common" | awk '{print $2}' | cut -d ':' -f1 | awk "/^software-properties-common$/")
    if [ "${APT_SOFTWARE_PROPERTIES_COMMON_INFO}" != "software-properties-common" ]; then
      sudo apt install -y ca-certificates apt-transport-https software-properties-common
      echo
    fi

    UBUNTU_MAJOR_RELEASE=$(cat /etc/lsb-release | grep -i 'DISTRIB_RELEASE' | cut -d "=" -f2 | cut -c 1-2)
    if [ "${UBUNTU_MAJOR_RELEASE}" -lt 26 ]; then
      PPA_STRING="ondrej"
      if grep -rqs "${PPA_STRING}" /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/; then
          echo "✅ '${PPA_STRING}' It has been already registered"

      else
          echo "⚠️ '${PPA_STRING}' Installing"
          echo

          LC_ALL=C.UTF-8 sudo add-apt-repository -y ppa:ondrej/php
          sudo apt-get update -y
      fi
      echo
    else
      echo ">>>> This Linux is Ubuntu ${UBUNTU_MAJOR_RELEASE}"
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # PHP - Install the packages
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> PHP - Install packages
    echo ">>>> PHP - Install packages"
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # PHP-FPM - Repair a version-mismatched configuration BEFORE apt runs
    # ------------------------------------------------------------------------------------------------------------------
    # Why this section must come **before** package installation:
    #
    # The dpkg postinst of phpX.Y-fpm runs `invoke-rc.d php X.Y-fpm restart`. On a machine that already
    # has PHP installed, a leftover broken configuration makes that restart die with exit 78 (EX_CONFIG),
    # and dpkg then fails the whole apt run with "old php X.Y-fpm package postinst maintainer script
    # subprocess failed", leaving the package unconfigured. In other words, **the install step cannot be
    # passed until the configuration is fixed** — execution never reaches the `PHP - Update the
    # configuration` section below.
    #
    # The form actually observed: the repository config hardcoded 8.4 and was copied as-is into
    # /etc/php/8.5/fpm/, so
    #   include=/etc/php/8.4/fpm/pool.d/*.conf  →  "Nothing matches the include pattern"
    #   pid/error_log = /run/php/php8.4-fpm.*   →  mismatch with the systemd unit
    # and with not a single pool loaded, FPM initialization failed.
    #
    # The regex does not pin the version literal — whichever X.Y is baked in, it is realigned to the
    # current PHP_VERSION. The same expression is reused in the config deployment step below, so it also
    # resolves the `__PHP_VERSION__` placeholder.
    PHP_VERSION_SED="s#__PHP_VERSION__#${PHP_VERSION}#g"
    PHP_VERSION_SED="${PHP_VERSION_SED}; s#/run/php/php[0-9]+\.[0-9]+-fpm#/run/php/php${PHP_VERSION}-fpm#g"
    PHP_VERSION_SED="${PHP_VERSION_SED}; s#/var/log/php[0-9]+\.[0-9]+-fpm#/var/log/php${PHP_VERSION}-fpm#g"
    PHP_VERSION_SED="${PHP_VERSION_SED}; s#/etc/php/[0-9]+\.[0-9]+/fpm#/etc/php/${PHP_VERSION}/fpm#g"
    PHP_VERSION_SED="${PHP_VERSION_SED}; s#/usr/share/php/[0-9]+\.[0-9]+/fpm#/usr/share/php/${PHP_VERSION}/fpm#g"

    PHP_FPM_REPAIRED="no"
    for fpmConfItem in "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf" "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"; do
        if [ -f "${fpmConfItem}" ]; then
            # Only touch a file that actually still carries a reference to some other version (a correct
            # file is left alone). `grep -o` extracts just the version references, then checks whether any
            # of them is not the current version — with no match at all, `grep -qv` returns 1 on empty
            # input, so the file is skipped naturally.
            if grep -qE "__PHP_VERSION__" "${fpmConfItem}" \
               || grep -oE "php[0-9]+\.[0-9]+-fpm|/etc/php/[0-9]+\.[0-9]+/fpm" "${fpmConfItem}" \
                  | grep -qv "${PHP_VERSION}"; then
                echo "  >> [FIX] Realigning version-mismatched configuration to ${PHP_VERSION}: ${fpmConfItem}"
                sudo sed -i -E "${PHP_VERSION_SED}" "${fpmConfItem}"
                PHP_FPM_REPAIRED="yes"
            fi
        fi
    done

    # After a repair, finish configuring any package left unconfigured by the earlier failure — skipping
    # this makes the `apt install` below stop again on the same dpkg error.
    if [ "${PHP_FPM_REPAIRED}" == "yes" ]; then
        echo
        echo "  >> [FIX] Configuring packages left unconfigured (dpkg --configure -a)"
        sudo dpkg --configure -a || true
        echo
    fi
    unset fpmConfItem PHP_FPM_REPAIRED

    # >>>> PHP - base packages - identical in dev and prod
    # php-cli is required in every environment: Symfony needs it for composer, bin/console and the
    # Messenger workers. php-fpm pulls it in transitively; declaring it keeps the requirement explicit.
    addPackageList="php${PHP_VERSION}-common php${PHP_VERSION}-cli php${PHP_VERSION}-fpm php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl php${PHP_VERSION}-uuid php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-bcmath php${PHP_VERSION}-redis php${PHP_VERSION}-pgsql php${PHP_VERSION}-amqp"

    # >>>> PHP - Xdebug is the only environment-specific package - development only, never in prod
    if [ "${ENVIRONMENT_NAME}" != "prod" ]; then
        addPackageList="${addPackageList} php${PHP_VERSION}-xdebug"
    fi

    (
    cd /tmp || return

    # Per-package guard keeps this idempotent, so a partially provisioned host still converges.
    for pkgItem in ${addPackageList}; do
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != "${pkgItem}" ]; then
            sudo apt install -y "${pkgItem}"
            echo
        fi
    done
    echo
    )

    # >>>> PHP-FPM - prod serves through FPM, so the service must survive a reboot
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        sudo systemctl enable "php${PHP_VERSION}-fpm"
        echo
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # PHP - Update the configuration
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Environment - the directory is selected by ENVIRONMENT_NAME (dev|prod), not by PHP_VERSION
    PHP_CONFIG_PATH="${PROJECT_PATH}/scripts/base/app/php/${ENVIRONMENT_NAME}"

    if [ -d "${PHP_CONFIG_PATH}" ]; then

        # >>>> PHP - Update configurations
        echo ">>>> PHP - Update configurations"
        echo

        # >>>> PHP - php.ini
        # Destination guard doubles as an "is this SAPI installed" check; source guard keeps
        # the copy optional so a missing file in one environment is not a hard failure.
        if [ -f "${PHP_CONFIG_PATH}/cli/php.ini" ] && [ -f "/etc/php/${PHP_VERSION}/cli/php.ini" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/cli/php.ini" "/etc/php/${PHP_VERSION}/cli/php.ini"
        fi

        # >>>> PHP - conf.d/20-xdebug.ini - dev only; prod ships no xdebug config
        # The phpX.Y-xdebug package runs `phpenmod xdebug`, which defaults to ALL SAPIs, so it symlinks
        # mods-available/xdebug.ini into both cli/conf.d and fpm/conf.d. --remove-destination replaces
        # that symlink with a real per-SAPI file; a plain `cp` would follow the symlink and overwrite the
        # shared mods-available copy, leaking the CLI settings into every other SAPI.
        for sapiItem in cli fpm; do
            XDEBUG_SOURCE="${PHP_CONFIG_PATH}/${sapiItem}/conf.d/20-xdebug.ini"
            XDEBUG_TARGET="/etc/php/${PHP_VERSION}/${sapiItem}/conf.d/20-xdebug.ini"
            if [ -f "${XDEBUG_SOURCE}" ] && [ -d "/etc/php/${PHP_VERSION}/${sapiItem}/conf.d" ]; then
                sudo cp -fv --remove-destination "${XDEBUG_SOURCE}" "${XDEBUG_TARGET}"
                sudo sed -i "s#__PROJECT_PATH__#${PROJECT_PATH}#g" "${XDEBUG_TARGET}"
            fi
        done
        echo

        # >>>> PHP-FPM - Update configurations
        echo ">>>> PHP-FPM - Update configurations"
        echo

        # >>>> PHP-FPM - php.ini - carries the [opcache] tuning, including opcache.preload in prod
        if [ -f "${PHP_CONFIG_PATH}/fpm/php.ini" ] && [ -f "/etc/php/${PHP_VERSION}/fpm/php.ini" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/fpm/php.ini" "/etc/php/${PHP_VERSION}/fpm/php.ini"
            sudo sed -i "s#__PROJECT_PATH__#${PROJECT_PATH}#g" "/etc/php/${PHP_VERSION}/fpm/php.ini"
        fi

        # >>>> PHP-FPM - php-fpm.conf
        # The repository source keeps the version as `__PHP_VERSION__` and substitutes it right after the
        # copy — the same scheme as `__PROJECT_PATH__` in php.ini. Previously the source hardcoded 8.4 and
        # was copied verbatim into /etc/php/${PHP_VERSION}/, so the moment PHP was upgraded the pool
        # include path pointed at an empty directory and FPM failed to boot (see the pre-repair section
        # above).
        if [ -f "${PHP_CONFIG_PATH}/fpm/php-fpm.conf" ] && [ -f "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/fpm/php-fpm.conf" "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf"
            sudo sed -i -E "${PHP_VERSION_SED}" "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf"
        fi

        # >>>> PHP-FPM - pool.d/www.conf
        if [ -f "${PHP_CONFIG_PATH}/fpm/pool.d/www.conf" ] && [ -f "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/fpm/pool.d/www.conf" "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"
            sudo sed -i -E "${PHP_VERSION_SED}" "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"
        fi

        # >>>> PHP-FPM - Validate the configuration (before any restart and before the next apt run)
        # Skipping validation leaves a broken configuration in place, which then breaks the whole apt run
        # at the postinst restart of the next phpX.Y-fpm upgrade. Better to fail loudly right here.
        if [ -x "/usr/sbin/php-fpm${PHP_VERSION}" ]; then
            echo
            echo ">>>> PHP-FPM - Validate configuration"
            if sudo "/usr/sbin/php-fpm${PHP_VERSION}" -t; then
                echo
            else
                echo
                echo "[ ERROR ] PHP-FPM configuration validation failed: /etc/php/${PHP_VERSION}/fpm/"
                echo "          Resolve the errors above first — left as is, the next apt run will fail"
                echo "          along with it at the php${PHP_VERSION}-fpm postinst restart."
                setExit
            fi
        fi

        # >>>> PHP-FPM - OPcache needs no file of its own: the phpX.Y-opcache package already provides
        # conf.d/10-opcache.ini (`zend_extension=opcache.so`), and all tuning now lives in the
        # [opcache] section of fpm/php.ini above.
        echo

    else
        echo "There is not the folder: ${PHP_CONFIG_PATH}"
        echo
    fi

    # >>>> PHP - Xdebug must never load in prod
    # prod does not install phpX.Y-xdebug, but a machine re-provisioned from dev can still carry the
    # package. phpdismod drops the conf.d symlinks for every SAPI so the extension stops loading.
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        if [ -f "/etc/php/${PHP_VERSION}/mods-available/xdebug.ini" ]; then
            echo ">>>> PHP - Xdebug - disable for all SAPIs (prod)"
            sudo phpdismod -v "${PHP_VERSION}" xdebug
            echo
        fi
    fi

    # >>>> PHP-FPM - prod serves through FPM, so it is always restarted.
    #
    # dev uses the Symfony local server, but **that is not a reason to skip the restart** — the package
    # installs the unit enabled, so FPM is running on dev machines too, and the configuration just fixed
    # takes effect only after a restart. A unit left in the failed state by an earlier failure also
    # recovers here. (Check that the unit exists first, for machines where it is absent or masked.)
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        sudo systemctl restart "php${PHP_VERSION}-fpm"
        echo
    elif systemctl list-unit-files "php${PHP_VERSION}-fpm.service" 2>/dev/null | grep -q "php${PHP_VERSION}-fpm.service"; then
        PHP_FPM_STATE=$(systemctl is-active "php${PHP_VERSION}-fpm" 2>/dev/null)
        if [ "${PHP_FPM_STATE}" != "inactive" ]; then
            echo ">>>> PHP-FPM - Restart (unit state: ${PHP_FPM_STATE})"
            sudo systemctl restart "php${PHP_VERSION}-fpm"
            sudo systemctl status "php${PHP_VERSION}-fpm" --no-pager | head -5
            echo
        fi
        unset PHP_FPM_STATE
    fi

    unset PHP_VERSION_SED

  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Composer
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> PHP - Composer"
  echo
  if [ -f /usr/local/bin/composer ]; then
    echo "Composer  : $(composer --version)"
  else
    (
      cd /tmp || return

      echo "    * Install composer"
      export COMPOSER_ALLOW_SUPERUSER=1
      curl -sS https://getcomposer.org/installer -o composer-setup.php
      sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
      sudo ln -s /usr/local/bin/composer /usr/bin/composer
      sudo rm -fv composer-setup.php
      echo

      echo "Composer  : $(composer --version)"
    )
  fi
  echo

  php -v
  echo

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Mac - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment


  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PHP
  echo ">>>> PHP"

  PHP_PKG=$(brew list | grep php)
  if [ -z "${PHP_PKG}" ]; then
    brew install "php@${PHP_VERSION}"
    echo
  fi

  echo
  echo "extension-dir : $(php-config --extension-dir)"
  echo

  # >>>> PHP - Extension - Xdebug is a development-only extension; never install it for prod
  if [ "${ENVIRONMENT_NAME}" != "prod" ]; then
    PHP_XDEBUG=$(pecl list | awk '/xdebug/ {print $0}' | cut -c 1-6)
    if [ "${PHP_XDEBUG}" ]; then
      pecl list | grep -i xdebug
    else
      export LC_CTYPE=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      pecl install xdebug
    fi
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Update the configuration
  # --------------------------------------------------------------------------------------------------------------------

    # >>>> Environment - the directory is selected by ENVIRONMENT_NAME (dev|prod), not by PHP_VERSION
    PHP_CONFIG_PATH="${PROJECT_PATH}/scripts/base/app/php/${ENVIRONMENT_NAME}"
    PHP_BREW_PATH="/opt/homebrew/etc/php/${PHP_VERSION}"

    if [ -d "${PHP_CONFIG_PATH}" ]; then

        # >>>> PHP - Update configurations
        echo ">>>> PHP - Update configurations"
        echo

        # >>>> PHP - php.ini
        # Destination guards use the Homebrew prefix, not /etc/php - macOS has no /etc/php,
        # so guarding on the Linux path made every copy below unreachable.
        if [ -f "${PHP_CONFIG_PATH}/cli/php.ini" ] && [ -f "${PHP_BREW_PATH}/php.ini" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/cli/php.ini" "${PHP_BREW_PATH}/php.ini"
        fi

        # >>>> PHP - conf.d/20-xdebug.ini - dev only; prod ships no xdebug config
        # Homebrew keeps one conf.d shared by the CLI and FPM SAPIs, so unlike Debian there is no
        # per-SAPI split here - the cli file is the single source for both.
        if [ -f "${PHP_CONFIG_PATH}/cli/conf.d/20-xdebug.ini" ] && [ -d "${PHP_BREW_PATH}/conf.d" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/cli/conf.d/20-xdebug.ini" "${PHP_BREW_PATH}/conf.d/20-xdebug.ini"
            sudo sed -i '' "s#__PROJECT_PATH__#${PROJECT_PATH}#g" "${PHP_BREW_PATH}/conf.d/20-xdebug.ini"
        fi
        echo

        # >>>> PHP-FPM - Update configurations
        echo ">>>> PHP-FPM - Update configurations"
        echo

        # >>>> PHP-FPM - php.ini
        if [ -f "${PHP_CONFIG_PATH}/fpm/php.ini" ] && [ -f "${PHP_BREW_PATH}/fpm/php.ini" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/fpm/php.ini" "${PHP_BREW_PATH}/fpm/php.ini"
        fi

        # >>>> PHP-FPM - php-fpm.conf
        # The `__PHP_VERSION__` in the repository source must be substituted — left unsubstituted, the
        # placeholder survives verbatim and FPM includes a path that does not exist. macOS `sed -i`
        # requires a backup-suffix argument, so an empty string ('') is passed (the syntax differs from
        # the Linux branch).
        if [ -f "${PHP_CONFIG_PATH}/fpm/php-fpm.conf" ] && [ -f "${PHP_BREW_PATH}/php-fpm.conf" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/fpm/php-fpm.conf" "${PHP_BREW_PATH}/php-fpm.conf"
            sudo sed -i '' "s#__PHP_VERSION__#${PHP_VERSION}#g" "${PHP_BREW_PATH}/php-fpm.conf"
        fi

        # >>>> PHP-FPM - pool.d/www.conf
        if [ -f "${PHP_CONFIG_PATH}/fpm/pool.d/www.conf" ] && [ -d "${PHP_BREW_PATH}/php-fpm.d" ]; then
            sudo cp -fv "${PHP_CONFIG_PATH}/fpm/pool.d/www.conf" "${PHP_BREW_PATH}/php-fpm.d/www.conf"
            sudo sed -i '' "s#__PHP_VERSION__#${PHP_VERSION}#g" "${PHP_BREW_PATH}/php-fpm.d/www.conf"
        fi
        echo

    else
        echo "There is not the folder: ${PHP_CONFIG_PATH}"
        echo
    fi

  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Composer
  # --------------------------------------------------------------------------------------------------------------------
  PHP_COMPOSER=$(brew list | grep composer)
  if [ "${PHP_COMPOSER}" ]; then
    echo "Composer  : $(composer --version)"
  else
    brew install composer
  fi
  echo

  php --version
  echo

  php --ini
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Symfony - Front-End
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Node
  if [ ! -f "/opt/homebrew/opt/node@${NODE_VERSION}/bin/node" ]; then
    (
      cd /tmp || return

      brew install "node@${NODE_VERSION}"
      echo

      brew unlink "node@${NODE_VERSION}" && brew link "node@${NODE_VERSION}"
      echo

      brew install yarn
      echo

      brew unlink yarn && brew link yarn
      echo
    )
  fi

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows - WSL2
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    # >>>> PHP
    echo ">>>> PHP"
    echo
  fi
  echo

else
  echo "Please check Operating System"
  setExit
fi
