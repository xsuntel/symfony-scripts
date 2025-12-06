#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - PHP - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # ------------------------------------------------------------------------------------------------------------------
    # PHP - Install the packages
    # ------------------------------------------------------------------------------------------------------------------

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

            # >>>> PHP-FPM - Update the latest version
            #local APT_SW_INFO="software-properties-common"
            #APT_SOFTWARE_PROPERTIES_COMMON_INFO=$(dpkg -l | grep -i "software-properties-common" | awk '{print $2}' | cut -d ':' -f1 | awk "/^software-properties-common$/")
            #if [ "${APT_SOFTWARE_PROPERTIES_COMMON_INFO}" != "software-properties-common" ]; then
            #  sudo apt install -y ca-certificates apt-transport-https software-properties-common
            #  sudo add-apt-repository -y ppa:ondrej/php
            #  sudo apt update -y
            #  echo
            #fi

            # >>>> PHP-FPM - required packages
            local addPackageList="php${PHP_VERSION} php${PHP_VERSION}-cli php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-fpm php${PHP_VERSION}-gd php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl php${PHP_VERSION}-uuid php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-bcmath"
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
            local addPackageList="php${PHP_VERSION}-opcache php${PHP_VERSION}-redis php${PHP_VERSION}-pgsql php${PHP_VERSION}-amqp"
            for pkgItem in ${addPackageList}; do
                local APT_PKG_INFO
                APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
                if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
                    sudo apt install -y ${pkgItem}
                    echo
                fi
            done
            echo


            # >>>> PHP-FPM - Remove some packages
            local delUserList="apache2-bin libapache2-mod-php${PHP_VERSION} php${PHP_VERSION}-cgi"
            for pkgItem in ${delUserList}; do
                local APT_PKG_INFO
                APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
                if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
                    sudo apt remove -y ${pkgItem}
                    echo
                fi
            done

            # >>>> PHP-FPM - configuration
            sudo systemctl enable php${PHP_VERSION}-fpm
            echo
            )
        fi

    else

        # >>>> PHP
        echo ">>>> PHP - Install packages"
        echo

        # >>>> PHP - required packages
        local addPackageList="php${PHP_VERSION} php${PHP_VERSION}-cli php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl php${PHP_VERSION}-uuid php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-bcmath"
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
        local addPackageList="php${PHP_VERSION}-redis php${PHP_VERSION}-amqp php${PHP_VERSION}-pgsql"
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

        # >>>> PHP-FPM - php.ini
        if [ -f /etc/php/${PHP_VERSION}/fpm/php.ini ]; then
            sudo cp -fv ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/${PHP_VERSION}/fpm/php_${ENVIRONMENT_NAME}.ini /etc/php/${PHP_VERSION}/fpm/php.ini
        fi

        # >>>> PHP-FPM - php-fpm.conf
        if [ -f /etc/php/${PHP_VERSION}/fpm/php-fpm.conf ]; then
            sudo cp -fv ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/${PHP_VERSION}/fpm/php-fpm_${ENVIRONMENT_NAME}.conf /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
        fi

        # >>>> PHP-FPM - pool.d/www.conf
        if [ -f /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf ]; then
            sudo cp -fv ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/${PHP_VERSION}/fpm/pool.d/www_${ENVIRONMENT_NAME}.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
        fi

        # >>>> PHP-FPM - conf.d/10-opcache.ini
        if [ -f /etc/php/${PHP_VERSION}/fpm/conf.d/10-opcache.ini ]; then
            sudo cp -fv ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/${PHP_VERSION}/fpm/conf.d/10-opcache_${ENVIRONMENT_NAME}.ini /etc/php/${PHP_VERSION}/fpm/conf.d/10-opcache.ini
        fi

        # >>>> PHP-FPM - conf.d/20-xdebug.ini
        if [ -f /etc/php/${PHP_VERSION}/fpm/conf.d/20-xdebug.ini ]; then
            sudo rm -fv /etc/php/${PHP_VERSION}/fpm/conf.d/20-xdebug.ini
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

        # >>>> PHP - php.ini
        if [ -f /etc/php/${PHP_VERSION}/cli/php.ini ]; then
            sudo cp -fv ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/${PHP_VERSION}/cli/php_${ENVIRONMENT_NAME}.ini /etc/php/${PHP_VERSION}/cli/php.ini
        fi

        # >>>> PHP - conf.d/20-xdebug.ini
        if [ -f /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini ]; then
            sudo cp -fv ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/${PHP_VERSION}/cli/conf.d/20-xdebug_${ENVIRONMENT_NAME}.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini
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

  #php -i | grep 'opcache\.enable '
  #php -i | grep 'opcache\.(enable_cli|jit|jit_buffer_size) '
  #echo

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

fi
