#!/bin/bash
# ======================================================================================================================
# Scripts - VM - Amazon Linux - Nginx - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Nginx
  (
    cd /tmp || return

    echo "- Install packages"
    sudo amazon-linux-extras install nginx${NGINX_VERSION} -y
    echo

    echo "- Enable this service"
    sudo systemctl enable nginx
    echo
  )

  # >>>> Nginx - Copy the configuration
  sudo rm -f /etc/nginx/*.default
  if [ -f /etc/nginx/nginx.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/nginx/nginx.conf /etc/nginx
  fi

  sudo rm -f /etc/nginx/conf.d/*
  if [ -f /etc/nginx/conf.d/default.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/nginx/conf.d/default.conf /etc/nginx/conf.d
  fi

  if [ -f /etc/nginx/conf.d/www.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/nginx/conf.d/www_${ENVIRONMENT_NAME}.conf /etc/nginx/conf.d/www.conf
  else
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/nginx/conf.d/www_${ENVIRONMENT_NAME}.conf /etc/nginx/conf.d/www.conf
  fi

  if [ -f /etc/nginx/conf.d/redirect.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/nginx/conf.d/redirect.conf /etc/nginx/conf.d
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Nginx - Update the Configuration
  sudo chown root:root /etc/nginx/nginx.conf
  sudo chown root:root /etc/nginx/conf.d/default.conf
  sudo chown root:root /etc/nginx/conf.d/symfony.conf
  sudo chown root:root /etc/nginx/conf.d/redirect.conf

  # >>>> Nginx - Directory
  sudo usermod -G nginx -a ec2-user
  sudo chown -R ec2-user:nginx /var/www

  # >>>> Nginx - Directory - Log
  sudo chown nginx:nginx -R /var/log/nginx
  sudo chown nginx:nginx -R /var/log/php-fpm

  # >>>> Nginx - PHP Lib
  if [ -d /var/lib/php ]; then
    sudo chown ec2-user:nginx -R /var/lib/php
    sudo chmod 777 /var/lib/php
  fi

  # >>>> Nginx - Configuration - Status
  nginx -t
  echo

  sudo systemctl restart nginx
fi
