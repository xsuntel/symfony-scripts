#!/bin/bash
# ======================================================================================================================
# Tools - Check this platform
# ======================================================================================================================
# >>>> Base
PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
cd "${PROJECT_PATH}" || exit
if [ -f ${PROJECT_PATH}/.env ]; then
  # >>>> Import .env file
  source ${PROJECT_PATH}/.env
  # >>>> Import a abstract file
  if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_abstract.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
  fi
else
  echo "Please check .env file : ${PROJECT_PATH}/.env" && exit
fi

# ----------------------------------------------------------------------------------------------------------------------
# Environment
# ----------------------------------------------------------------------------------------------------------------------

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE}"
  echo "---------------------------------------------------------------------------------------------------------------"
  PS3="Menu: "
  select num in "dev" "exit"; do
    case "$REPLY" in
    1)
      # >>>> DEV Environment
      ENVIRONMENT_NAME="dev"
      break
      ;;
    2)
      echo "exit()"
      setEnd
      ;;
    *)
      echo "[ ERROR ] Unknown Command"
      setEnd
      ;;
    esac
  done
  echo
  echo "- PROJECT ENV : ${ENVIRONMENT_NAME}"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Platform
# ----------------------------------------------------------------------------------------------------------------------

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PLATFORM OS : ${PLATFORM_TYPE}"
  echo -n
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Kernel
      # ----------------------------------------------------------------------------------------------------------------
      echo "- PLATFORM Kernel : $(uname -r)"
      echo

      # >>>> Check kernel list
      dpkg --list | grep linux-image
      echo

      echo "sudo apt-get purge linux-image-<old_version> -f"
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # User
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Update a user permission
      if [ ! -f /etc/sudoers.d/$USER.conf ]; then
        sudo echo "${USER} ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
      else
        ls -ltr /etc/sudoers.d/$USER.conf
      fi

      # >>>> Remove some packages
      local delUserList="sync news uucp games"
      for userItem in ${delUserList}; do
        local USER_LIST
        USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
        if [ "${USER_LIST}" == ${userItem} ]; then
          sudo userdel ${userItem}
        fi
      done
    fi
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Kernel
      # ----------------------------------------------------------------------------------------------------------------
      echo "- PLATFORM Kernel : $(uname -r)"
      echo

      # >>>> Check kernel list

      # ----------------------------------------------------------------------------------------------------------------
      # User
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Update a user permission
      if [ ! -f /etc/sudoers.d/$USER.conf ]; then
        sudo echo "${USER} ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
      else
        ls -ltr /etc/sudoers.d/$USER.conf
      fi

      echo -n
    fi
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Kernel
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Check kernel list

      # ----------------------------------------------------------------------------------------------------------------
      # User
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Update a user permission

      echo -n
    fi
  else
    echo "Please check Operating System"
    setEnd
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Project
# ----------------------------------------------------------------------------------------------------------------------

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${ABSTRACT_NAME}"
  echo -n
  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# App
# ----------------------------------------------------------------------------------------------------------------------

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # --------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # --------------------------------------------------------------------------------------------------------------------
    php -r 'xdebug_info();'
    #php -r 'xdebug_info();' | less -R
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # --------------------------------------------------------------------------------------------------------------------
    # MacOS
    # --------------------------------------------------------------------------------------------------------------------
    echo -n
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # --------------------------------------------------------------------------------------------------------------------
    # Windows
    # --------------------------------------------------------------------------------------------------------------------
    echo -n
  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Cache
# ----------------------------------------------------------------------------------------------------------------------

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Database
# ----------------------------------------------------------------------------------------------------------------------

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - PostgreSQL"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Server
# ----------------------------------------------------------------------------------------------------------------------

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server - Nginx"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Scripts
# ----------------------------------------------------------------------------------------------------------------------

setCloud() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Cloud"
  echo "---------------------------------------------------------------------------------------------------------------"
  # --------------------------------------------------------------------------------------------------------------------
  # Cloud - AWS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> AWS - Import a CLI file
  if [ -f ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh ]; then
    source ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh" && exit
  fi
  echo

  # >>>> AWS - Import a Config file
  if [ -f ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh ]; then
    source ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh" && exit
  fi
}

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    echo

    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Hardware
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Check status
      echo ">>>> CPU"
      top -b -n 1 | head -n 5
      echo

      echo ">>>> Memory"
      sudo sysctl -w vm.min_free_kbytes=2000000                                                           # default :16384
      sudo sysctl -w vm.vfs_cache_pressure=10000                                                          # default : 100
      sudo sysctl -w vm.drop_caches=2
      sudo sysctl -w vm.swappiness=0
      echo

      echo 2 > sudo /proc/sys/vm/drop_caches
      echo 0 > sudo /proc/sys/vm/swappiness
      sudo swapoff -a && sudo swapon -a
      free -m
      echo

      sudo slabtop -o | grep dentry
      echo

      cat /proc/meminfo | grep -i anon
      echo

      echo ">>>> SSD"
      df -h
      echo

      echo ">>>> Network"
      netstat -napo | grep -i time_wait
      echo
      # ----------------------------------------------------------------------------------------------------------------
      # Firewall
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Check status
      local UFW_STATUS
      UFW_STATUS=$(systemctl is-active ufw)
      if [ "${UFW_STATUS}" == "active" ]; then
        sudo ufw status verbose
        echo
      else
        sudo systemctl enable ufw.service
        sudo systemctl start ufw.service
        sudo ufw enable
      fi
      echo

      # >>>> Reset current rules
      sudo systemctl stop ufw
      sudo ufw reset
      echo

      # >>>> Update default rules
      sudo ufw default deny
      echo

      # >>>> Update allowed services
      sudo ufw allow ntp                                                                                         # ntp
      sudo ufw allow ipp                                                                                         # print

      # >>>> Update allowed ports App
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9000
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9001
      sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 9003

      # >>>> Update allowed ports Cache - Redis
      sudo ufw allow 6379/tcp

      # >>>> Update allowed ports Database - PostgreSQL
      sudo ufw allow 5432/tcp

      # >>>> Update allowed ports Server - Nginx
      #sudo ufw allow http                                                                                        # web
      sudo ufw allow 8080/tcp
      sudo ufw allow 8081/tcp
      sudo ufw allow 8082/tcp
      sudo ufw allow 8083/tcp
      echo

      # >>>> Update allowed remote desktop
      #sudo ufw allow from 192.168.0.0/24 to any port 3389
      #sudo ufw allow from 192.168.0.0/24 to any port 3389 comment $(whoami)
      #echo

      # >>>> Check default rules
      sudo systemctl start ufw
      sudo ufw reload
      echo

      sudo systemctl status ufw --no-pager
      echo

      sudo ufw status verbose
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Services
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Remove some services
      local delPackageList="cups cups-browsed whoopsie kerneloops openvpn apport"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt purge -y ${pkgItem}
          echo
        fi
      done

      # >>>> Disable some services
      local delPackageList="ModemManager"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          udo systemctl disable --now ${pkgItem}
          echo
        fi
      done

      sudo systemctl mask --now colord

      systemctl --user mask --now gsd-print-notifications
      systemctl --user mask --now gsd-wacom
      systemctl --user mask --now gsd-smartcard
      systemctl --user mask --now gsd-color

      # >>>> Disable gnome-shell extensions          https://manpages.ubuntu.com/manpages/focal/en/man1/gsettings.1.html
      if [ -d ~/.local/share/gnome-shell/extensions ]; then
        for ext in $(/usr/bin/ls ~/.local/share/gnome-shell/extensions); do
          gnome-shell-extension-tool -d $ext;
        done
      fi
      gsettings set org.gnome.shell disable-user-extensions true
      echo

      service --status-all | grep '\[ + \]'
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Packages
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Install additional packages
      local addPackageList="nmap"
      for pkgItem in ${addPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt install -y ${pkgItem}
          echo
        fi
      done

      # >>>> Install additional packages
      local addPackageList="putty putty-tools"
      for pkgItem in ${addPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt install -y ${pkgItem}
          echo
        fi
      done

      if [ -f /bin/nmap ]; then
        nmap localhost
        #less /etc/services
      fi
      echo

      # >>>> Install additional packages - Remote Desktop
      #local addPackageList="xrdp"
      #for pkgItem in ${addPackageList}; do
      #  local APT_PKG_INFO
      #  APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      #  if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
      #    sudo apt install -y ${pkgItem}
      #    echo
      #  fi
      #  sudo usermod -a -G ssl-cert xrdp
      #  sudo systemctl enable xrdp
      #  sudo systemctl restart xrdp
      #done

      # Remove evolution packages
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
        sudo rm /usr/share/indicators/messages/applications/evolution
      fi

      # >>>> Remove some packages
      local delPackageList="grub-pc-bin evolution evolution-common evolution-plugins evolution-data-server xrdp"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt purge -y ${pkgItem}
          echo
        fi
      done

      sudo apt autoremove -y

    fi
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      echo -n
    fi
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      echo -n
    fi
  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------

setGit() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - Git"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Global
  echo "# >>>>> Git - Config - Global"
  git config --global --list
  echo

  # >>>> Local
  echo "# >>>>> Git - Config - Local"
  git config --local --list
  echo
}

setIDE() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - IDE"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # --------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # --------------------------------------------------------------------------------------------------------------------
    echo -n "- PhpStorm : "
    local PHPSTORM_STATUS
    PHPSTORM_STATUS=$(ls -d /opt/PhpStorm* 2>&1 | head -1 | cut -c 6-13)
    if [ -d /snap/phpstorm ]; then
      echo "It has been installed"
    elif [ "${PHPSTORM_STATUS}" == "PhpStorm" ]; then
      echo "It has been installed"
    else
      echo "It has not been installed"
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      echo -n
    fi
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      echo -n
    fi
  else
    echo "Please check Operating System"
    setExit
  fi
}

setWebBrowser() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - WebBrowser"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ======================================================================================================================
# Main
# ======================================================================================================================

# >>>> Start
setStart

# >>>> Environment
setEnvironment

# >>>> Platform
setPlatform

# >>>> Project
setProject

# ----------------------------------------------------------------------------------------------------------------------
# >>>> App - PHP Framework - Symfony
# ----------------------------------------------------------------------------------------------------------------------
#setPhp

# >>>> Cache
#setRedis

# >>>> Database
#setPostgreSQL

# >>>> Server
#setNginx

# ----------------------------------------------------------------------------------------------------------------------
# >>>> Scripts
# ----------------------------------------------------------------------------------------------------------------------
#setCloud
#setDocker
setVM

# ----------------------------------------------------------------------------------------------------------------------
# >>>> Tools
# ----------------------------------------------------------------------------------------------------------------------
#setGit
setIDE
#setWebBrowser

# >>>> End
setEnd
