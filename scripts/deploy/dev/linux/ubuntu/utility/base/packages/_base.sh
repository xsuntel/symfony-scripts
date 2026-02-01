#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - Linux - Ubuntu - Packages
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      # >>>> Packages
      echo ">>>> Linux - Packages"
      echo

      local addPackageList="shfmt shellcheck"
      for pkgItem in ${addPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt install -y "${pkgItem}"
          echo
        fi
      done

      # >>>> Packages - Remove default applications
      local delPackageList="gnome-mahjongg gnome-sudoku aisleriot"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" == "${pkgItem}" ]; then
          sudo apt remove -y "${pkgItem}"
          echo
        fi
      done

      # >>>> Packages - Disable gnome-shell extensions            https://manpages.ubuntu.com/manpages/focal/en/man1/gsettings.1.html
      local delPackageList="evolution evolution-common evolution-plugins evolution-data-server"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" == "${pkgItem}" ]; then
          sudo apt purge -y "${pkgItem}"
          echo
        fi
      done

      if [ -d ~/.local/share/gnome-shell/extensions ]; then
        for ext in $(/usr/bin/ls ~/.local/share/gnome-shell/extensions); do
          gnome-shell-extension-tool -d $ext;
        done
      fi
      gsettings set org.gnome.shell disable-user-extensions true
      echo

      service --status-all | grep '\[ + \]'
      echo

      # >>>> Packages - Remove openssh-server
      local SSHD_STATUS
      SSHD_STATUS=$(systemctl is-active sshd)
      if [ "${SSHD_STATUS}" == "active" ]; then
        sudo systemctl stop sshd
        sudo systemctl disable sshd
      fi
      echo

      local delPackageList="openssh-server"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" == "${pkgItem}" ]; then
          sudo apt purge -y "${pkgItem}"
          echo
        fi
      done

      # >>>> Packages - Remove gnome-remote-desktop
      local delPackageList="gnome-remote-desktop openvpn"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" == "${pkgItem}" ]; then
          sudo apt purge -y "${pkgItem}"
          echo
        fi
      done

      local delUserList="gnome-remote-desktop nm-openvpn"
      for userItem in ${delUserList}; do
        local USER_LIST
        USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
        if [ "${USER_LIST}" == "${userItem}" ]; then
          sudo userdel "${userItem}"
        fi
      done

      # >>>> Packages - Remove related network packages
      local delPackageList="putty putty-tools nmap remmina ModemManager amagent speech-dispatcher"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" == "${pkgItem}" ]; then
          sudo apt purge -y "${pkgItem}"
          echo
        fi
      done

      # >>>> Packages - Remove openvpn
      local delPackageList="ubuntu-advantage-tools ubuntu-advantage-pro unattended-upgrades"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" == "${pkgItem}" ]; then
          sudo apt purge -y "${pkgItem}"
          echo
        fi
      done

      # >>>> Packages Files
      echo ">>>> Linux - Cache Files"
      echo

      if [ -d /tmp ]; then
        sudo rm -rf /tmp/*
        sudo rm -rf /tmp/.*
      fi

      if [ -d /tmp/.org.chromium.Chromium.exrVvc ]; then
        sudo rm -rf /tmp/.org.chromium.Chromium.exrVvc
      fi

      if [ -d "/home/${LOGNAME}/.cache" ]; then
        sudo rm -rf "/home/${LOGNAME}/.cache/*"
      fi

      sudo apt autoremove -y
      echo

    fi
fi
