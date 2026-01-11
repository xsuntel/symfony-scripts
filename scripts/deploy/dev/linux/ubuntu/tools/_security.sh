#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - Linux - Ubuntu - Security
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu Desktop
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      # >>>> User
      echo ">>>> Linux - Users"
      echo

      if [ ! -f /etc/sudoers.d/$USER ]; then
        sudo touch /etc/sudoers.d/$USER
        sudo echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
      fi


      local delUserList="list sync games news uucp uuidd irc speech-dispatcher ftp tcpdump snmp snmpd fwupd-refresh tss"
      for userItem in ${delUserList}; do
        local USER_LIST
        USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
        if [ "${USER_LIST}" == ${userItem} ]; then
          sudo userdel ${userItem}
        fi
      done

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
      echo

    else

      # >>>> User
      echo ">>>> Linux - Users"
      echo

      if [ -f /etc/sudoers.d/$USER ]; then
        sudo rm -f /etc/sudoers.d/$USER
      fi

    fi
fi
