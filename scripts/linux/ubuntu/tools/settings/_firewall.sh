#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Firewall in Dev Environment
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Firewall
  local addPackageList="ufw"
  for pkgItem in ${addPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
      sudo apt install -y ${pkgItem}
      echo
    fi
    sudo systemctl enable ufw
    sudo ufw enable
  done

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Firewall
  local UFW_STATUS
  UFW_STATUS=$(systemctl is-active ufw)
  if [ "${UFW_STATUS}" == "active" ]; then
    sudo systemctl stop ufw
  fi

  # >>>> Reset current rules
  sudo ufw reset
  echo

  # >>>> Update default rules
  sudo ufw default deny
  echo

  # >>>> Update allowed services
  sudo ufw allow ntp                                                                             # NTP

  # >>>> Update allowed ports for App      - PHP
  #sudo ufw allow 9001/tcp                                                                       # Xdebug - DBGp Proxy
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9003                                           # Xdebug

  # >>>> Update allowed ports for Cache    - Redis
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 6379

  # >>>> Update allowed ports for Database - PostgreSQL
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5432

  # >>>> Update allowed ports for Message  - RabbitMQ
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5672

  # >>>> Update allowed ports for Server   - Nginx
  sudo ufw allow 8000/tcp                                                                       # Local Server - 0
  sudo ufw allow 8010/tcp                                                                       # Local Server - 1
  sudo ufw allow 8030/tcp                                                                       # Local Server - 2
  sudo ufw allow 8030/tcp                                                                       # Local Server - 3
  echo

  # >>>> Update allowed ports for Tools    - xRDP
  #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389 comment $(whoami)

  # >>>> Check default rules
  sudo systemctl start ufw

  sudo systemctl status ufw --no-pager
  echo
fi
