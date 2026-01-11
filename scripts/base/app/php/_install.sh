#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - Linux - Ubuntu - PHP - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # ------------------------------------------------------------------------------------------------------------------
    # PHP - Install the packages
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> PHP - Check Repository
    echo ">>>> PHP - Check Repository"
    echo

    local APT_SW_INFO="software-properties-common"
    APT_SOFTWARE_PROPERTIES_COMMON_INFO=$(dpkg -l | grep -i "software-properties-common" | awk '{print $2}' | cut -d ':' -f1 | awk "/^software-properties-common$/")
    if [ "${APT_SOFTWARE_PROPERTIES_COMMON_INFO}" != "software-properties-common" ]; then
      sudo apt install -y ca-certificates apt-transport-https software-properties-common
      echo
    fi

    PPA_STRING="ondrej/php"
    if grep -rqs "$PPA_STRING" /etc/apt/sources.list /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/; then
        echo "✅ '$PPA_STRING' It has been already registered"
        echo
    else
        echo "⚠️ '$PPA_STRING' Installing"
        echo

        LC_ALL=C.UTF-8 sudo add-apt-repository -y ppa:ondrej/php
        sudo apt-get update -y
        echo
    fi

    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then

        # >>>> PHP-FPM
        echo ">>>> PHP-FPM - Install packages"
        echo

        local PHP_FPM_STATUS
        PHP_FPM_STATUS=$(dpkg -l | grep -i "php${PHP_VERSION}-fpm" | awk '{print $2}' | cut -d ':' -f1 | awk "/^php${PHP_VERSION}-fpm$/")
        if [ "${PHP_FPM_STATUS}" != "php${PHP_VERSION}-fpm" ]; then
            (
            cd /tmp || return

            # >>>> PHP-FPM - Remove some packages
            local delUserList="php${PHP_VERSION}-cgi php${PHP_VERSION}-xdebug"
            for pkgItem in ${delUserList}; do
                local APT_PKG_INFO
                APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
                if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
                    sudo apt remove -y ${pkgItem}
                    echo
                fi
            done

            # >>>> PHP-FPM - required packages
            local addPackageList="php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-fpm php${PHP_VERSION}-opcache php${PHP_VERSION}-gd php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl php${PHP_VERSION}-uuid php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-bcmath"
            for pkgItem in ${addPackageList}; do
                local APT_PKG_INFO
                APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
                if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
                    sudo apt install -y ${pkgItem}
                    echo
                fi
            done
            echo

            # >>>> PHP-FPM - additional packages
            local addPackageList="php${PHP_VERSION}-redis php${PHP_VERSION}-pgsql php${PHP_VERSION}-amqp"
            for pkgItem in ${addPackageList}; do
                local APT_PKG_INFO
                APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
                if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
                    sudo apt install -y ${pkgItem}
                    echo
                fi
            done
            echo

            # >>>> PHP-FPM - configuration
            sudo systemctl enable php${PHP_VERSION}-fpm
            echo
            )
        fi

    else

        # >>>> PHP
        echo ">>>> PHP - Install packages"
        echo

        # >>>> PHP - Remove some packages
        local delUserList="php${PHP_VERSION}-cgi php${PHP_VERSION}-fpm"
        for pkgItem in ${delUserList}; do
            local APT_PKG_INFO
            APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
            if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
                sudo apt remove -y ${pkgItem}
                echo
            fi
        done
        echo

        # >>>> PHP - required packages
        local addPackageList="php${PHP_VERSION}-cli php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-opcache php${PHP_VERSION}-gd php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl php${PHP_VERSION}-uuid php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-bcmath"
        for pkgItem in ${addPackageList}; do
            local APT_PKG_INFO
            APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
            if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
                sudo apt install -y ${pkgItem}
                echo
            fi
        done
        echo

        # >>>> PHP - additional packages
        local addPackageList="php${PHP_VERSION}-redis php${PHP_VERSION}-pgsql php${PHP_VERSION}-amqp"
        for pkgItem in ${addPackageList}; do
            local APT_PKG_INFO
            APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
            if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
                sudo apt install -y ${pkgItem}
                echo
            fi
        done
        echo

        # >>>> PHP - options packages
        local addPackageList="php${PHP_VERSION}-xdebug"
        for pkgItem in ${addPackageList}; do
            local APT_PKG_INFO
            APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
            if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
                sudo apt install -y ${pkgItem}
                echo
            fi
        done
        echo
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # PHP - Update the configuration
    # ------------------------------------------------------------------------------------------------------------------

    if [ ! -d /var/log/php ]; then
        sudo mkdir -p /var/log/php
    fi

    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then

        # >>>> PHP-FPM - Update configurations
        echo ">>>> PHP-FPM - Update configurations"
        echo

        if [ -d ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION} ]; then
            # >>>> PHP-FPM - php.ini
            if [ -f /etc/php/${PHP_VERSION}/fpm/php.ini ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/fpm/php.ini /etc/php/${PHP_VERSION}/fpm/php.ini
            fi

            # >>>> PHP-FPM - php-fpm.conf
            if [ -f /etc/php/${PHP_VERSION}/fpm/php-fpm.conf ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/fpm/php-fpm.conf /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
            fi

            # >>>> PHP-FPM - pool.d/www.conf
            if [ -f /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/fpm/pool.d/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
            fi

            # >>>> PHP-FPM - conf.d/10-opcache.ini
            if [ -f /etc/php/${PHP_VERSION}/fpm/conf.d/10-opcache.ini ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/fpm/conf.d/10-opcache.ini /etc/php/${PHP_VERSION}/fpm/conf.d/10-opcache.ini
            fi

            #php -i | grep 'opcache\.enable '
            #php -i | grep 'opcache\.(enable_cli|jit|jit_buffer_size) '
            #echo

            # >>>> PHP-FPM - conf.d/20-xdebug.ini
            if [ -f /etc/php/${PHP_VERSION}/fpm/conf.d/20-xdebug.ini ]; then
                sudo rm -fv /etc/php/${PHP_VERSION}/fpm/conf.d/20-xdebug.ini
            fi
        else
            echo "There is not the folder: ${PROJECT_PATH}"
            echo
        fi

        if [ -f /var/log/php/xdebug.log ]; then
            sudo rm -fv /var/log/php/xdebug.log
        fi

        # >>>> PHP-FPM - Remove log files
        if [ -f /var/log/php/php${PHP_VERSION}-fpm.log ]; then
            sudo chmod -R 777 /var/log/php/php${PHP_VERSION}-fpm.log
            sudo cat /dev/null > /var/log/php/php${PHP_VERSION}-fpm.log
        fi

        if [ -f /var/log/php/php-fpm.log ]; then
            sudo chmod -R 777 /var/log/php/php-fpm.log
            sudo cat /dev/null > /var/log/php/php-fpm.log
        else
            touch /var/log/php/php-fpm.log
            sudo chmod -R 777 /var/log/php/php-fpm.log
        fi
        echo

        sudo systemctl restart php${PHP_VERSION}-fpm

        # --------------------------------------------------------------------------------------------------------------------
        # PHP - Log
        # --------------------------------------------------------------------------------------------------------------------

        # Setting up or Fixing File Permissions - https://symfony.com/doc/current/setup/file_permissions.html
        HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"
        if [ ! -d /var/log/php ]; then
            sudo mkdir -p /var/log/php
            sudo chown -R ${HTTPDUSER}:${HTTPDUSER} /var/log/php
            sudo chmod -R 777 /var/log/php
            echo
        fi

    else

        # >>>> PHP - Update configurations
        echo ">>>> PHP - Update configurations"
        echo

        if [ -d ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION} ]; then
            # >>>> PHP - php.ini
            if [ -f /etc/php/${PHP_VERSION}/cli/php.ini ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/cli/php.ini /etc/php/${PHP_VERSION}/cli/php.ini
            fi

            # >>>> PHP - conf.d/20-xdebug.ini
            if [ -f /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini
            fi
        else
            echo "There is not the folder: ${PROJECT_PATH}"
            echo
        fi

        if [ ! -f /var/log/php/xdebug.log ]; then
            sudo touch /var/log/php/xdebug.log
        fi

        sudo chmod 777 /var/log/php/xdebug.log

        # >>>> PHP - Remove log files
        if [ -f /var/log/php/php${PHP_VERSION}-fpm.log ]; then
            sudo rm -rf /var/log/php/php${PHP_VERSION}-fpm.log
        fi

        if [ -f /var/log/php/php-fpm.log ]; then
            sudo rm -Rf /var/log/php/php-fpm.log
        fi
        echo

    fi

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
  # Platform - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment


  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PHP
  echo ">>>> PHP"

  local PHP_PKG
  PHP_PKG=$(brew list | grep php)
  if [ "${PHP_PKG}" ]; then
    local CURRENT_PHP_VERSION
    CURRENT_PHP_VERSION=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
  else
    brew install php@${PHP_VERSION}
    echo
  fi

  echo
  echo "extension-dir : $(php-config --extension-dir)"
  echo

  # >>>> PHP - Extension
  local PHP_XDEBUG
  PHP_XDEBUG=$(pecl list | awk '/xdebug/ {print $0}' | cut -c 1-6)
  if [ ${PHP_XDEBUG} ]; then
    pecl list | grep -i xdebug
  else
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    pecl install xdebug
  fi
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Update the configuration
  # --------------------------------------------------------------------------------------------------------------------

    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then

        # >>>> PHP-FPM - Update configurations
        echo ">>>> PHP-FPM - Update configurations"
        echo

        if [ -d ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION} ]; then
            # >>>> PHP-FPM - php.ini
            if [ -f /etc/php/${PHP_VERSION}/fpm/php.ini ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/fpm/php.ini /opt/homebrew/etc/php/${PHP_VERSION}/fpm/php.ini
            fi

        else
            echo "There is not the folder: ${PROJECT_PATH}"
            echo
        fi

    else

        # >>>> PHP - Update configurations
        echo ">>>> PHP - Update configurations"
        echo

        if [ -d ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION} ]; then
            # >>>> PHP - php.ini
            if [ -f /etc/php/${PHP_VERSION}/cli/php.ini ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/cli/php.ini /opt/homebrew/etc/php/${PHP_VERSION}/php.ini
            fi

            # >>>> PHP - conf.d/20-xdebug.ini
            if [ -f /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini ]; then
                sudo cp -fv ${PROJECT_PATH}/scripts/base/app/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini /opt/homebrew/etc/php/${PHP_VERSION}/conf.d/20-xdebug.ini
            fi
        else
            echo "There is not the folder: ${PROJECT_PATH}"
            echo
        fi

    fi



  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Composer
  # --------------------------------------------------------------------------------------------------------------------
  local PHP_COMPOSER
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
  local NODE_PKG
  NODE_PKG=$(brew list | grep node@${NODE_VERSION})
  if [ ! -f /opt/homebrew/opt/node@${NODE_VERSION}/bin/node ]; then
    (
      cd /tmp || return

      brew install node@${NODE_VERSION}
      echo

      brew unlink node@${NODE_VERSION} && brew link node@${NODE_VERSION}
      echo

      brew install yarn
      echo

      brew unlink yarn && brew link yarn
      echo
    )
  fi

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows
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

