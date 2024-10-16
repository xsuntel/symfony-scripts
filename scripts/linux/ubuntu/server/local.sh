#!/bin/bash
# ======================================================================================================================
# Tools - Check this platform in Dev Environment
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
  source ${PROJECT_PATH}/scripts/base/_abstract.sh
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# ----------------------------------------------------------------------------------------------------------------------
# System Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Environment"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Select one of some environments
  PS3="Menu: "
  select num in "dev" "exit"; do
    case "$REPLY" in
    1)
      # >>>> Dev Environment
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

# >>>> Platform

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PLATFORM OS : ${PLATFORM_TYPE}"
  echo
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # ------------------------------------------------------------------------------------------------------------------
    # Boot
    # ------------------------------------------------------------------------------------------------------------------

    echo ">>>> Linux - Hardware"
    echo

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
    # >>>> Network - ipv6
    sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
    sudo cat /proc/sys/net/ipv6/conf/all/disable_ipv6
    echo

    netstat -napo | grep -i time_wait
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # Firewall
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Linux - Firewall"
    echo

    # >>>> Firewall
    local addPackageList="ufw"
    for pkgItem in ${addPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
        sudo apt install -y ${pkgItem}
        sudo systemctl enable ${pkgItem}
        sudo systemctl start ${pkgItem}
        echo
      fi
    done

    # >>>> Firewall
    local UFW_STATUS
    UFW_STATUS=$(systemctl is-active ufw)
    if [ "${UFW_STATUS}" == "active" ]; then
      sudo ufw disable
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
    sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 15672

    # >>>> Update allowed ports for Server   - Nginx
    sudo ufw allow 8000/tcp                                                                       # Local Server - 0
    sudo ufw allow 8010/tcp                                                                       # Local Server - 1
    sudo ufw allow 8030/tcp                                                                       # Local Server - 2
    sudo ufw allow 8030/tcp                                                                       # Local Server - 3
    echo

    # >>>> Update allowed ports for Tools    - xRDP
    #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389
    #sudo ufw allow from 192.168.0.0/24 to 192.168.0.0/24 port 3389 comment $(whoami)
    #sudo ufw allow from 192.168.0.0/24 to any port 3389 proto tcp
    #sudo ufw allow 3389/tcp
    #echo

    sudo ufw disable

    sudo ufw enable

    sudo systemctl status ufw --no-pager
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # Hosts
    # ------------------------------------------------------------------------------------------------------------------

    echo ">>>> Linux - Hosts"
    echo

    local PROJECT_HOST_NAME
    PROJECT_HOST_NAME=$(grep -i "symfony.local" /etc/hosts | awk '{print $2}' | head -n 1)
    if [ ! "${PROJECT_HOST_NAME}" ]; then
      echo $'\n127.0.0.1 symfony.local' | sudo tee -a /etc/hosts
      echo $'\n127.0.0.1 api.symfony.local' | sudo tee -a /etc/hosts
      echo $'\n127.0.0.1 cdn.symfony.local' | sudo tee -a /etc/hosts
      echo $'\n127.0.0.1 www.symfony.local' | sudo tee -a /etc/hosts

      echo ">>>> Hosts"
      sudo grep -v '#' /etc/hosts
      echo
    fi
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # Kernel
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Linux - Kernel"
    echo

    echo "- PLATFORM Kernel : $(uname -r)"
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
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # Packages
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Linux - Packages"
    echo

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

    # >>>> Install packages for xRDP

    #sudo apt-get -y install xrdp xfce4
    #sudo systemctl enable xrdp

    # >>>> Add a user
    #sudo adduser xrdp ssl-cert

    # >>>> xfce4
    #echo xfce4-session >~/.xsession

    # >>>> Update firewal
    #sudo vi /etc/xrdp/xrdp.ini
    # port=192.168.0.100:3389

    # >>>> Restart the service
    #sudo systemctl restart xrdp

    # >>>> Check network ports
    #sudo netstat -plnt | grep xrdp

    # >>>> Check a log
    #tail -n 50 /var/log/syslog

    # sudo vi /etc/xrdp/startwm.sh

    # unset DBUS_SESSION_BU ADDRESS
    # unset XDG_RUNTIME_DIR
    #
    # test -x /etc/X11/Xsession && exec /etc/X11/Xession            <----   주석
    # exec /bin/sh /etc/X11/Xession                                 <----   주석
    #
    # test -x /usr/bin/startxfce4 && exec /usr/bin/startxfce4
    # exec /bin/sh /usr/bin/startxfce4

    # ------------------------------------------------------------------------------------------------------------------
    # Services
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Linux - Services"
    echo

    # >>>> Disable default services
    local delPackageList="ModemManager"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
        sudo systemctl disable --now ${pkgItem}
        echo
      fi
    done

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

    # >>>> Disable Ubuntu Pro
    sudo apt remove -y --purge ubuntu-advantage*

    sudo apt autoremove -y
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # User
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Linux - User : ${USER}"
    echo

    # >>>> Remove some packages
    local delUserList="lp sync games uucp news"
    for userItem in ${delUserList}; do
      local USER_LIST
      USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
      if [ "${USER_LIST}" == ${userItem} ]; then
        sudo userdel ${userItem}
      fi
    done

    # >>>> Update a user permission
    if [ ! -f /etc/sudoers.d/$USER ]; then
      sudo echo "${USER} ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
    else
      sudo cat /etc/sudoers.d/$USER
    fi

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# >>>> Project

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${PROJECT_NAME}"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# CDN - Content Delivery Networks
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - CDN - Content Delivery Networks"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Docker - Containers"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - VM - Instance"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Check Hardware
  echo ">>>> CPU"
  top -b -n 1 | head -n 5
  echo

  echo ">>>> Memory"
  free -m
  echo

  echo ">>>> SSD"
  df -h
  echo

  echo ">>>> Network"
  netstat -napo | grep -i time_wait
  echo

  echo ">>>> Temp files"
  if [ -d /tmp ]; then
    sudo rm -rfv /tmp/*
  fi

  if [ -d /home/${LOGNAME}/.cache ]; then
    sudo rm -rf /home/${LOGNAME}/.cache/*
  fi
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Operating System
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> Operating System"
  echo

  # >>>> TimeZone
  echo "TimeZone"
  timedatectl
  echo

  # >>>> Firewall
  local UFW_STATUS
  UFW_STATUS=$(systemctl is-active ufw)
  if [ "${UFW_STATUS}" == "inactive" ]; then
    sudo systemctl start ufw
    sudo systemctl status ufw --no-pager
    echo
  fi
  echo "Firewall   : ${UFW_STATUS}"
  echo

  # >>>> Cron
  local CRON_STATUS
  CRON_STATUS=$(systemctl is-active cron)
  if [ "${CRON_STATUS}" == "inactive" ]; then
    sudo systemctl start cron
    sudo systemctl status cron --no-pager
    echo
  fi
  echo "Cron       : ${CRON_STATUS}"
  echo
  crontab -l
  echo

  # >>>> Supervisor
  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(systemctl is-active supervisor)
  if [ "${SUPERVISOR_STATUS}" == "inactive" ]; then
    sudo systemctl start supervisor
    sudo systemctl status supervisor --no-pager
    echo
  fi
  echo "Supervisor : ${SUPERVISOR_STATUS}"
  echo

  # >>>> Rsyslog
  local RSYSLOG_STATUS
  RSYSLOG_STATUS=$(systemctl is-active rsyslog)
  if [ "${RSYSLOG_STATUS}" == "inactive" ]; then
    sudo systemctl start rsyslog
    sudo systemctl status rsyslog --no-pager
    echo
  fi
  echo "Rsyslog    : ${RSYSLOG_STATUS}"
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Software Bundles
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> Software Bundles"
  echo

  # >>>> App
  local PHP_STATUS
  PHP_STATUS=$(systemctl is-active php${PHP_VERSION}-fpm)
  if [ "${PHP_STATUS}" == "inactive" ]; then
    sudo systemctl start php${PHP_VERSION}-fpm
    sudo systemctl status php${PHP_VERSION}-fpm --no-pager
    echo
  fi
  echo "App         - PHP-FPM    : ${PHP_STATUS}"
  echo

  # >>>> Cache
  local REDIS_STATUS
  REDIS_STATUS=$(systemctl is-active redis)
  if [ "${REDIS_STATUS}" == "inactive" ]; then
    sudo systemctl start redis
    sudo systemctl status redis --no-pager
    echo
  fi
  echo "Cache       - Redis      : ${REDIS_STATUS}"
  echo

  # >>>> Database
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local POSTGRESQL_STATUS
    POSTGRESQL_STATUS=$(systemctl is-active postgresql)
    if [ "${POSTGRESQL_STATUS}" == "inactive" ]; then
      sudo systemctl start redis
      sudo systemctl status redis --no-pager
      echo
    fi
    echo "Database    - PostgreSQL : ${POSTGRESQL_STATUS}"
    echo
  fi

  # >>>> Messenger
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local RABBITMQ_STATUS
    RABBITMQ_STATUS=$(systemctl is-active rabbitmq-server)
    if [ "${RABBITMQ_STATUS}" == "inactive" ]; then
      sudo systemctl start rabbitmq-server
      sudo systemctl status rabbitmq-server --no-pager
      echo
    fi
    echo "Message     - RabbitMQ   : ${RABBITMQ_STATUS}"
    echo
  fi

  # >>>> Server
  local NGINX_STATUS
  NGINX_STATUS=$(systemctl is-active nginx)
  if [ "${NGINX_STATUS}" == "inactive" ]; then
    sudo systemctl start nginx
    sudo systemctl status nginx --no-pager
    echo
  fi
  echo "Server      - Nginx      : ${NGINX_STATUS}"
  echo
}

# ======================================================================================================================
# START
# ======================================================================================================================

# >>>> Start
setStart

# ----------------------------------------------------------------------------------------------------------------------
# System Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment
setEnvironment

# >>>> Platform
setPlatform

# >>>> Project
setProject

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
#setPhp

# >>>> Cache
#setRedis

# >>>> Database
#setPostgreSQL

# >>>> Server
#setNginx

# ----------------------------------------------------------------------------------------------------------------------
# CDN - Content Delivery Networks
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------
#setDocker

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
