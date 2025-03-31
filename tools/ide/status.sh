#!/bin/bash
# ======================================================================================================================
# Tools - IDE - Status
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
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
  echo

  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_environment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_environment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_environment.sh" && exit
  fi
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
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Release
    if [ -f /etc/lsb-release ]; then
      echo ">>>> Release"
      echo

      cat /etc/lsb-release
      echo
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Release
    echo ">>>> Release"
    echo

    sw_vers
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Release
    echo ">>>> Release"
    echo

    ver
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
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------o

    # >>>> PHP-FPM
    local PHP_STATUS
    PHP_STATUS=$(systemctl is-active php${PHP_VERSION}-fpm)
    if [ "${PHP_STATUS}" == "inactive" ]; then
      sudo systemctl start php${PHP_VERSION}-fpm
      sudo systemctl status php${PHP_VERSION}-fpm --no-pager
      echo
    fi
    echo "PHP-FPM    : ${PHP_STATUS}"
    echo

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> PHP-FPM
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> PHP-FPM
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
  echo

  # >>>> Symfony Framework
  if [ -d app ]; then
    (
      cd app || return

      if [ -f bin/console ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # Symfony Framework - Requirements:
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Requirements:"
      echo

      if [ -f composer.lock ]; then
        symfony check:require
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Symfony Framework - Security Vulnerabilities
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Security Vulnerabilities"
      echo

      if [ -f composer.lock ]; then
        symfony check:security
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Symfony Framework - Variable Export
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Variable Export"
      echo

      # >>>> Variable Export
      symfony var:export --multiline
      echo

      fi
    )
  else
    echo "[ ERROR ] There is not a folder : app"
    setExit
  fi
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Redis
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local REDIS_STATUS
      REDIS_STATUS=$(systemctl is-active redis)
      if [ "${REDIS_STATUS}" == "inactive" ]; then
        sudo systemctl start redis
        sudo systemctl status redis --no-pager
        echo
      fi
      echo "REDIS      : ${REDIS_STATUS}"
      echo
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Redis
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Redis
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> PostgreSQL
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local POSTGRESQL_STATUS
      POSTGRESQL_STATUS=$(systemctl is-active postgresql)
      if [ "${POSTGRESQL_STATUS}" == "inactive" ]; then
        sudo systemctl start postgresql
        sudo systemctl status postgresql --no-pager
        echo
      fi
      echo "PostgreSQL : ${POSTGRESQL_STATUS}"
      echo
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> PostgreSQL
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> PostgreSQL
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# >>>> Message

setRabbitMQ() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Message"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> RabbitMQ
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local RABBITMQ_STATUS
      RABBITMQ_STATUS=$(systemctl is-active rabbitmq-server)
      if [ "${RABBITMQ_STATUS}" == "inactive" ]; then
        sudo systemctl start rabbitmq-server
        sudo systemctl status rabbitmq-server --no-pager
        echo
      fi
      echo "RabbitMQ   : ${RABBITMQ_STATUS}"
      echo
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> RabbitMQ
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> RabbitMQ
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------o

    # >>>> Nginx
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
      local NGINX_STATUS
      NGINX_STATUS=$(systemctl is-active nginx)
      if [ "${NGINX_STATUS}" == "inactive" ]; then
        sudo systemctl start nginx
        sudo systemctl status nginx --no-pager
        echo
      fi
      echo "NGINX      : ${NGINX_STATUS}"
      echo
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Nginx
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Nginx
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - CDN"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" != "Linux" ]; then

  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"


    # >>>> Docker Desktop                                                               https://docs.docker.com/reference/
    #echo ">>>> Docker Version"
    #echo
    #docker version
    #echo

    #echo ">>>> Docker Info"
    #echo
    #docker info
    #echo

    # >>>> Docker - Process
    echo ">>>> Docker Process"
    echo
    docker ps -a | grep -i ${PROJECT_NAME}
    echo

    # >>>> Docker Desktop - docker-compose
    echo ">>>> checking docker compose"
    echo
    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env.app" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" config
    echo

  else
    echo -n
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  local HOSTIP
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Hosts
    echo ">>>> Hosts"
    echo
    sudo grep -v '#' /etc/hosts
    echo

    # >>>> Hardware
    echo ">>>> CPU"
    echo
    top -b -n 1 | head -n 5
    echo

    echo ">>>> Memory"
    echo
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo slabtop -o | grep dentry
      echo

      cat /proc/meminfo | grep -i anon
      echo

      sudo mount -o remount,size=2G tmpfs
      echo
    fi

    free -m
    echo

    echo ">>>> SSD"
    echo
    df -h
    echo

    echo ">>>> Network"
    echo
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # >>>> Network - ipv6
      sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
      sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
      sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
      sudo cat /proc/sys/net/ipv6/conf/all/disable_ipv6
      echo
    fi

    nmcli device status
    echo

    # >>>> Ubuntu - UFW
    sudo ufw status verbose
    echo

    netstat -napotl | grep -i LISTEN | grep -v tcp6
    echo

    netstat -napo | grep -i time_wait
    echo

    echo ">>>> Processor"
    echo

    # >>>> Rsyslog
    local RSYSLOG_STATUS
    RSYSLOG_STATUS=$(systemctl is-active rsyslog)
    if [ "${RSYSLOG_STATUS}" == "inactive" ]; then
      sudo systemctl start rsyslog
      sudo systemctl status rsyslog --no-pager
      echo
    fi
    echo
    echo "Rsyslog    : ${RSYSLOG_STATUS}"
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

    sudo supervisorctl status
    echo

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Hosts
    echo ">>>> Hosts"
    echo
    grep -v '#' /etc/hosts
    echo

    HOSTIP=$(ifconfig en0 | grep -e 'inet\s' | awk '{print $2}')
    echo "- HOST     IP : ${HOSTIP}"
    echo

    echo ">>>> Supervisor : ${SUPERVISOR_STATUS}"
    echo

    ps -A | grep messenger:consume
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Hosts
    echo ">>>> Hosts"
    echo
    grep -v '#' /windows/system32/drivers/etc/hosts
    echo

    HOSTIP = $(Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null}).IPv4Address.IPAddress
    echo "- HOST     IP : ${HOSTIP}"

  else
    echo "Please check Operating System"
    setExit
  fi
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
setPhp

# >>>> Cache
setRedis

# >>>> Database
setPostgreSQL

# >>>> Message
setRabbitMQ

# >>>> Server
setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd