#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Nginx - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  echo
  # >>>> Apache2
  if [ -f /etc/apache2/apache2.conf ]; then
    # >>>> APACHE2 - Test files
    if [ -f /var/www/html/index.nginx-debian.html ]; then
      sudo rm -rf /var/www/html
    fi

    # >>>> APACHE2 - Process
    sudo systemctl stop apache2
    sudo systemctl disable apache2
    sudo apt purge -y apache2
    sudo fuser -k 80/tcp
  fi

  # >>>> Remove log files
  if [ -f /var/log/nginx/www_access.log ]; then
    sudo chmod 777 /var/log/nginx/www_access.log
    sudo cat /dev/null > /var/log/nginx/www_access.log
  fi

  # >>>> Remove log files
  if [ -f /var/log/nginx/www_error.log ]; then
    sudo chmod 777 /var/log/nginx/www_error.log
    sudo cat /dev/null > /var/log/nginx/www_error.log
  fi
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Nginx
  local REDIS_STATUS
  NGINX_STATUS=$(dpkg -l | grep -i "nginx" | awk '{print $2}' | cut -d ':' -f1 | awk "/^nginx$/")
  if [ "${NGINX_STATUS}" != "nginx" ]; then
    # >>>> PHP - required packages
    local addPackageList="nginx"
    for pkgItem in ${addPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
        sudo apt install -y ${pkgItem}
        echo
      fi
    done
    echo

    echo "- Enable this service"
    sudo systemctl enable nginx
    echo

    sudo apt autoremove -y
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Nginx - Configuration
  sudo rm -f /etc/nginx/*.default

  if [ -f /etc/nginx/nginx.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/etc/nginx/nginx_${ENVIRONMENT_NAME}.conf /etc/nginx/nginx.conf
  fi

  if [ -f /etc/nginx/conf.d/www.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/etc/nginx/conf.d/www_${ENVIRONMENT_NAME}.conf /etc/nginx/conf.d/www.conf
  else
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/etc/nginx/conf.d/www_${ENVIRONMENT_NAME}.conf /etc/nginx/conf.d/www.conf
  fi

  if [ -d /etc/nginx/sites-available ]; then
    sudo rm -fv /etc/nginx/sites-available/*
  fi

  if [ -d /etc/nginx/sites-enabled ]; then
    sudo rm -fv /etc/nginx/sites-enabled/*
  fi

  sudo chown -R root:root /etc/nginx
  sudo chown -R root:root /var/log/nginx
  sudo chmod -R 755 /var/log/nginx
  echo

  # >>>> Nginx - Symfony - Setting up or Fixing File Permissions - https://symfony.com/doc/current/setup/file_permissions.html
  HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"
  sudo usermod -a -G "${HTTPDUSER}" "$(whoami)"

  # --------------------------------------------------------------------------------------------------------------------
  # Check the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Nginx - Status
  sudo nginx -v
  echo

  sudo nginx -t
  echo

  sudo systemctl restart nginx

fi
