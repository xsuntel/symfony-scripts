#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Packages - Local
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  echo ">>>> Linux - Packages"
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Remove installed packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Firewall - SSH - Ubuntu Desktop
  local SSHD_STATUS
  SSHD_STATUS=$(systemctl is-active sshd)
  if [ "${SSHD_STATUS}" == "active" ]; then
    sudo systemctl stop sshd
    sudo systemctl disable sshd
  fi
  echo

  # >>>> Remove related network packages
  local delPackageList="cups cups-browsed whoopsie kerneloops apport openvpn openssh-server putty putty-tools nmap xrdp gnome-remote-desktop"
  for pkgItem in ${delPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
      sudo apt purge -y ${pkgItem}
      echo
    fi
  done

  # >>>> Remove additional packages
  if [ -f /etc/needrestart/needrestart.conf ]; then
    sudo apt purge -y needrestart
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Remove installed applications
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Remove default applications
  local delPackageList="libreoffice thunderbird remmina gnome-mahjongg gnome-sudoku aisleriot"
  for pkgItem in ${delPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
      sudo apt remove -y ${pkgItem}
      echo
    fi
  done


  # >>>> Remove evolution packages
  if [ -f /usr/libexec/evolution-addressbook-factory ]; then
    sudo chmod -x /usr/libexec/evolution-addressbook-factory
  fi
  if [ -f /usr/libexec/evolution-calendar-factory ]; then
    sudo chmod -x /usr/libexec/evolution-calendar-factory
  fi
  if [ -f /usr/libexec/evolution-data-server/evolution-alarm-notify ]; then
    sudo chmod -x /usr/libexec/evolution-data-server/evolution-alarm-notify
  fi
  if [ -f /usr/libexec/evolution-source-registry ]; then
    sudo chmod -x /usr/libexec/evolution-source-registry
  fi

  if [ -d /usr/share/indicators/messages/applications/evolution ]; then
    sudo rm -rf /usr/share/indicators/messages/applications/evolution
  fi

  local delPackageList="grub-pc-bin evolution evolution-common evolution-plugins evolution-data-server"
  for pkgItem in ${delPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
      sudo apt purge -y ${pkgItem}
      echo
    fi
  done
fi
