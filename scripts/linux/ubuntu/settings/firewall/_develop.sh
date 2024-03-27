#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Firewall
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
  sudo ufw allow ntp                                                                                         # ntp
  sudo ufw allow ipp                                                                                         # print

  # >>>> Update allowed ports for App      - PHP
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9000                                                       # Xdebug
  #sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9001
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9003                                                       # Xdebug

  # >>>> Update allowed ports for Cache    - Redis
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 6379

  # >>>> Update allowed ports for Database - PostgreSQL
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 5432

  # >>>> Update allowed ports for Server   - Nginx
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port http
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port https
  sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 8000
  echo

  # >>>> Update allowed ports for Tools


  # >>>> Check default rules
  sudo systemctl start ufw
  sudo systemctl status ufw --no-pager
  echo
fi
