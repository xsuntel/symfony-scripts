#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Security
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu Desktop
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Kernel
    echo ">>>> Linux - Kernel : $(uname -r)"
    echo

    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo systemctl daemon-reload
      echo

      # >>>> Check kernel list
      local NOW_KERNEL_VERSION=$(uname -r | cut -d '-' -f 1,2)
      local DEL_KERNEL_VERSION=$(dpkg --list | grep linux-image- |grep -v linux-image-${OLD_KERNEL_VERSION} | grep -v linux-image-generic-hwe |awk  '{print $2}')

      if [ ${DEL_KERNEL_VERSION} ]; then
        dpkg --list | grep linux-image
        echo

        echo "sudo apt-get purge -y ${DEL_KERNEL_VERSION} -f"
        echo
      fi

      # >>>> Update Kernel - Network - ipv4
      sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1
      echo
    fi

    # >>>> Directories
    echo ">>>> Linux - Directories"
    echo

    sudo chown root:root /etc/sysctl.conf
    sudo chmod 600 /etc/sysctl.conf
    sudo ls -l /etc/sysctl.conf

    sudo chown root:root /etc/hosts
    sudo chmod 600 /etc/hosts
    sudo ls -l /etc/hosts

    sudo chown root:root /etc/passwd
    sudo chmod 644 /etc/passwd
    sudo ls -l /etc/passwd

    sudo chown root:root /etc/shadow
    sudo chmod 400 /etc/shadow
    sudo ls -l /etc/shadow

    sudo chown root:root /etc/rsyslog.conf
    sudo chmod 640 /etc/rsyslog.conf
    sudo ls -l /etc/rsyslog.conf

    sudo chown root:root /etc/services
    sudo chmod 644 /etc/services
    sudo ls -l /etc/services

    sudo chown root:root /etc/crontab
    sudo chmod 640 /etc/crontab

    sudo chown root:root /etc/cron.d/
    sudo chmod 640 /etc/cron.d/

    sudo chown root:root /etc/cron.daily/
    sudo chmod 640 /etc/cron.daily/

    sudo chown root:root /etc/cron.hourly/
    sudo chmod 640 /etc/cron.hourly/

    sudo chown root:root /etc/cron.monthly/
    sudo chmod 640 /etc/cron.monthly/

    sudo chown root:root /etc/cron.weekly/
    sudo chmod 640 /etc/cron.weekly/

    sudo chown root:root /etc/cron.yearly/
    sudo chmod 640 /etc/cron.yearly/

    if [ -f /etc/hosts.equiv ]; then
      sudo rm -rf /etc/hosts.equiv
    fi

    if [ -d ~/.rhosts ]; then
      sudo rm -rf ~/.rhosts
    fi

    if [ -f /etc/xdg/autostart/org.gnome.SettingsDaemon.Sharing.desktop ]; then
      systemctl --user mask org.gnome.SettingsDaemon.Sharing.service
    fi

    if [ -f /etc/xdg/autostart/org.gnome.SettingsDaemon.Smartcard.desktop ]; then
      systemctl --user mask org.gnome.SettingsDaemon.Smartcard.service
    fi

    if [ -f /etc/xdg/autostart/org.gnome.SettingsDaemon.Wacom.desktop ]; then
      systemctl --user mask org.gnome.SettingsDaemon.Wacom.service
    fi

    # >>>> User
    echo ">>>> Linux - Users"
    echo

    local delUserList="list sync games news uucp uuidd irc speech-dispatcher ftp tcpdump snmp snmpd"
    for userItem in ${delUserList}; do
      local USER_LIST
      USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
      if [ "${USER_LIST}" == ${userItem} ]; then
        sudo userdel ${userItem}
      fi
    done

    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local delUserList="fwupd-refresh tss"
      for userItem in ${delUserList}; do
        local USER_LIST
        USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
        if [ "${USER_LIST}" == ${userItem} ]; then
          sudo userdel ${userItem}
        fi
      done
    fi

    if [ -f /etc/sudoers.d/$USER ]; then
      sudo rm -f /etc/sudoers.d/$USER
    fi

    #if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    #  if [ ! -f /etc/sudoers.d/$USER ]; then
    #    sudo touch /etc/sudoers.d/$USER
    #    sudo echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
    #  fi
    #else
    #  if [ -f /etc/sudoers.d/$USER ]; then
    #    sudo rm -f /etc/sudoers.d/$USER
    #  fi
    #fi
    #echo

    # >>>> Packages
    echo ">>>> Linux - Packages"
    echo

    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

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
        if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
          sudo apt purge -y ${pkgItem}
          echo
        fi
      done

    fi

    # >>>> Packages - Remove gnome-remote-desktop
    local delPackageList="gnome-remote-desktop"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
        sudo apt purge -y ${pkgItem}
        echo
      fi
    done

    local delUserList="gnome-remote-desktop"
    for userItem in ${delUserList}; do
      local USER_LIST
      USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
      if [ "${USER_LIST}" == ${userItem} ]; then
        sudo userdel ${userItem}
      fi
    done

    # >>>> Packages - Remove openvpn
    local delPackageList="openvpn"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
        sudo apt purge -y ${pkgItem}
        echo
      fi
    done

    local delUserList="nm-openvpn"
    for userItem in ${delUserList}; do
      local USER_LIST
      USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
      if [ "${USER_LIST}" == ${userItem} ]; then
        sudo userdel ${userItem}
      fi
    done

    # >>>> Packages - Remove related applications
    local delPackageList="speech-dispatcher"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
        sudo apt remove -y --purge ubuntu-advantage-pro
        echo
      fi
    done

    # >>>> Packages - Remove related network packages
    local delPackageList="putty putty-tools nmap remmina ModemManager amagent"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
        sudo apt remove -y --purge ubuntu-advantage-pro
        echo
      fi
    done

    # >>>> Packages - Remove openvpn
    local delPackageList="ubuntu-advantage-tools ubuntu-advantage-pro unattended-upgrades"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
        sudo apt purge -y ${pkgItem}
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

    if [ -d /home/${LOGNAME}/.cache ]; then
      sudo rm -rf /home/${LOGNAME}/.cache/*
    fi

    sudo apt autoremove -y
    echo
fi
