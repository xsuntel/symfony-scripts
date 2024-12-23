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
    sudo ufw allow 3389/tcp
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
      sudo systemctl start postgresql
      sudo systemctl status postgresql --no-pager
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
