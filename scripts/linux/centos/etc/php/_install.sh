#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - CentOS - PHP
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PHP
  if [ ! -f /etc/yum.repos.d/remi-modular.repo ]; then
  local CENTOS
  CENTOS=$(cat /etc/centos-release | tr -dc '0-9.' | cut -d \. -f1)
  local PHP
  PHP=$(echo ${PHP_VERSION} | tr -d '.')

  # >>>> Packages
  sudo dnf install dnf-utils https://rpms.remirepo.net/enterprise/remi-release-${CENTOS}.rpm -y
  sudo dnf module list php -y
  sudo dnf module reset php -y
  sudo dnf module enable php:remi-${PHP_VERSION} -y
  sudo dnf install -y php php-{bcmath,cli,common,curl,fpm,gd,intl,mbstring,opcache,pdo,mysql,process,soap,uuid,xml,zip} --skip-broken
  #sudo dnf install -y php php-{bcmath,cli,common,dba,dbg,devel,embedded,enchant,ffi,fpm,gd,gmp,imap,intl,ldap,litespeed,mbstring,mysqlnd,odbc,opcache,pdo,pgsql,process,snmp,soap} --skip-broken

  # >>>> Driver
  #sudo dnf install -y php"${PHP}"-php-pecl-mongodb --skip-broken
  #if [ ! -f /etc/php.d/40-mongodb.ini ]; then
  #  sudo echo extension=/opt/remi/php"${PHP}"/root/usr/lib64/php/modules/mongodb.so >/etc/php.d/40-mongodb.ini
  #fi

  # >>>> Xdebug                                                                              https://xdebug.org/
  #if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
  #  sudo dnf install -y php"${PHP}"-php-pecl-xdebug3 --skip-broken
  #  echo
  #fi

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PHP - Update the configuration
  # >>>> php.ini
  if [ -f /etc/php.ini ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/centos/etc/php_${ENVIRONMENT_NAME}.ini /etc/php.ini
  fi
  # >>>> php-fpm.conf
  if [ -f /etc/php-fpm.d/php-fpm.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/centos/etc/php-fpm.d/php-fpm_${ENVIRONMENT_NAME}.conf /etc/php-fpm.d/php-fpm.conf
  fi
  # >>>> 10-opcache.ini
  if [ -f /etc/php.d/10-opcache.ini ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/centos/etc/php.d/10-opcache_${ENVIRONMENT_NAME}.ini /etc/php.d/10-opcache.ini
  fi
  # >>>> 20-xdebug.ini
  if [ -f /etc/php.d/20-xdebug.ini ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/centos/etc/php.d/20-xdebug_${ENVIRONMENT_NAME}.ini /etc/php.d/20-xdebug.ini
  fi

  # >>>> PHP - Directory - Log
  sudo mkdir -p /var/log/php
  sudo chmod -R 777 /var/log/php
  sudo chown -R nginx:nginx /var/log/php


  sudo systemctl restart php${PHP_VERSION}-fpm

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
  echo "---------------------------------------------------------------------------------------------------------------"
  echo
fi
