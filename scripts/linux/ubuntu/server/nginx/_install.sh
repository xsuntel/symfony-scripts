#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Nginx - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # >>>> Apache2
  if [ -f /etc/apache2/apache2.conf ]; then
    sudo systemctl stop apache2
    sudo systemctl disable apache2
    sudo apt purge -y apache2
    sudo fuser -k 80/tcp
  fi

  if [ -d /var/www/html ]; then
    sudo rm -rf /var/www/html
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Nginx - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Nginx
  echo ">>>> Nginx"
  echo

  local NGINX_STATUS
  NGINX_STATUS=$(dpkg -l | grep -i "nginx" | awk '{print $2}' | cut -d ':' -f1 | awk "/^nginx$/")
  if [ "${NGINX_STATUS}" != "nginx" ]; then
    sudo apt install -y nginx
    echo

    sudo systemctl enable nginx
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Nginx - Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Nginx - Configuration
  sudo rm -f /etc/nginx/*.default

  if [ -f /etc/nginx/nginx.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/server/nginx/nginx_${ENVIRONMENT_NAME}.conf /etc/nginx/nginx.conf
  fi

  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    # >>>> Project
    PROJECT_NAME=$(basename "$(realpath ${PROJECT_PATH})")
    if [ -f /etc/nginx/conf.d/www.conf ]; then
      sudo rm -f /etc/nginx/conf.d/www.conf
    fi
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/server/nginx/conf.d/www_${ENVIRONMENT_NAME}.conf /etc/nginx/conf.d/www.conf
  else
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/server/nginx/conf.d/www_${ENVIRONMENT_NAME}.conf /etc/nginx/conf.d/www.conf
  fi

  if [ -d /etc/nginx/sites-available ]; then
    sudo rm -fv /etc/nginx/sites-available/*
  fi

  if [ -d /etc/nginx/sites-enabled ]; then
    sudo rm -fv /etc/nginx/sites-enabled/*
  fi

  # >>>> Nginx - Remove log files
  if [ -f /var/log/nginx/www_access.log ]; then
    sudo chmod 777 /var/log/nginx/www_access.log
    sudo cat /dev/null > /var/log/nginx/www_access.log
  fi

  # >>>> Nginx - Remove log files
  if [ -f /var/log/nginx/www_error.log ]; then
    sudo chmod 777 /var/log/nginx/www_error.log
    sudo cat /dev/null > /var/log/nginx/www_error.log
  fi

  # >>>> Nginx - Delete logs files
  if [ -f /var/log/nginx/www_access.log.1 ]; then
    sudo rm -fv /var/log/nginx/www_access.log.*
    echo
  fi

  # >>>> Nginx - Delete logs files
  if [ -f /var/log/nginx/www_error.log.1 ]; then
    sudo rm -fv /var/log/nginx/www_error.log.*
    echo
  fi
  echo

  # >>>> Nginx - Update permissions
  sudo chown -R root:root /etc/nginx
  sudo chown -R root:root /var/log/nginx
  sudo chmod -R 755 /var/log/nginx
  echo

  # >>>> Nginx - Symfony - Setting up or Fixing File Permissions - https://symfony.com/doc/current/setup/file_permissions.html
  HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"
  sudo usermod -a -G "${HTTPDUSER}" "$(whoami)"

  # --------------------------------------------------------------------------------------------------------------------
  # Nginx - Check status
  # --------------------------------------------------------------------------------------------------------------------

  local NGINX_STATUS
  NGINX_STATUS=$(systemctl is-active nginx)
  if [ "${NGINX_STATUS}" == "active" ]; then
    sudo systemctl restart nginx
    echo
  else
    sudo systemctl start nginx
    echo
  fi

  sudo nginx -v
  echo

  sudo nginx -t
  echo

fi
