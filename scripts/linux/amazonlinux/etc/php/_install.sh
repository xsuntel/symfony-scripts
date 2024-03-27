#!/bin/bash
# ======================================================================================================================
# Scripts - VM - Amazon Linux - PHP - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PHP
  local PHP_FPM_STATUS
  PHP_FPM_STATUS=$(sudo systemctl is-enabled php-fpm)
  if [ "${PHP_FPM_STATUS}" == "enabled" ]; then
    sudo systemctl is-active php-fpm
  else
    (
      cd /tmp || return

      sudo yum-config-manager --disable 'remi-php*'
      sudo yum-config-manager --setopt="remi-php${PHP_VERSION}.priority=5" --enable remi-php${PHP_VERSION}
      echo

      sudo yum install -y php
      sudo yum install -y php-{cli,common,devel,fpm,gd,intl,markdown,mbstring,mcrypt,opcache,pdo,pear,pgsql,soap,sodium,xml} \
                php-pecl-redis --skip-broken

      sudo systemctl enable php-fpm
      echo

      # >>>> Database
      sudo amazon-linux-extras install postgresql14 --skip-broken
      echo
    )
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PHP - Update the configuration
  # >>>> php.ini
  if [ -f /etc/php.ini ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/php/php_${ENVIRONMENT_NAME}.ini /etc/php.ini
  fi
  # >>>> php-fpm.conf
  if [ -f /etc/php-fpm.d/php-fpm.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/php/php-fpm.d/php-fpm_${ENVIRONMENT_NAME}.conf /etc/php-fpm.d/php-fpm.conf
  fi
  # >>>> 10-opcache.ini
  if [ -f /etc/php.d/10-opcache.ini ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/php/php.d/10-opcache_${ENVIRONMENT_NAME}.ini /etc/php.d/10-opcache.ini
  fi
  # >>>> 20-xdebug.ini
  if [ -f /etc/php.d/20-xdebug.ini ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/php/php.d/20-xdebug_${ENVIRONMENT_NAME}.ini /etc/php.d/20-xdebug.ini
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
