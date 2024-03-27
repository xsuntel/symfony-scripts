#!/bin/bash
# ======================================================================================================================
# Scripts - Project - Status
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$0")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
  source ${PROJECT_PATH}/scripts/base/_abstract.sh
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# >>>> Environment

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE}"
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
  echo -n

  local HOSTIP
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu - Packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Release
    if [ -f /etc/lsb-release ]; then
      echo ">>>> Release"
      cat /etc/lsb-release
      echo
    fi

    # >>>> Hosts
    echo ">>>> Hosts"
    sudo grep -v '#' /etc/hosts
    echo

    # >>>> HostIP
    echo ">>>> Docker Host IP"
    HOSTIP=$(ip route get 1 | awk '{print $NF;exit}')
    echo "- HOST     IP : ${HOSTIP}"

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Release
    echo ">>>> Release"
    sw_vers
    echo

    # >>>> Hosts
    echo ">>>> Hosts"
    grep -v '#' /etc/hosts
    echo

    # >>>> HostIP
    echo ">>>> Docker Host IP"
    HOSTIP=$(ifconfig en0 | grep -e 'inet\s' | awk '{print $2}')
    echo "- HOST     IP : ${HOSTIP}"

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Release
    echo ">>>> Release"
    ver
    echo

    # >>>> Hosts
    echo ">>>> Hosts"
    grep -v '#' /windows/system32/drivers/etc/hosts
    echo

    # >>>> HostIP
    echo ">>>> Docker Host IP"
    HOSTIP = $(Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null}).IPv4Address.IPAddress
    echo "- HOST     IP : ${HOSTIP}"

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
# Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - PostgreSQL"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server - Nginx"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo
}


# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Cloud"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux
    # ------------------------------------------------------------------------------------------------------------------

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
    netstat -napo | grep -i LISTEN
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
    echo "-------------------------------------------------------------------------------------------------------------"
    echo

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

    # >>>> Redis
    local REDIS_STATUS
    REDIS_STATUS=$(systemctl is-active redis)
    if [ "${REDIS_STATUS}" == "inactive" ]; then
      sudo systemctl start redis
      sudo systemctl status redis --no-pager
      echo
    fi
    echo "REDIS      : ${REDIS_STATUS}"
    echo

    # >>>> Nginx
    local NGINX_STATUS
    NGINX_STATUS=$(systemctl is-active nginx)
    if [ "${NGINX_STATUS}" == "inactive" ]; then
      sudo systemctl start nginx
      sudo systemctl status nginx --no-pager
      echo
    fi
    echo "NGINX      : ${NGINX_STATUS}"
    echo

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> PHP - Symfony - Setting up or Fixing File Permissions - https://symfony.com/doc/current/setup/file_permissions.html
    (
      cd app || return

      echo "There are not the related files"
    )

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> PHP - Symfony - Setting up or Fixing File Permissions - https://symfony.com/doc/current/setup/file_permissions.html
    (
      cd app || return

      echo "There are not the related files"
    )

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Docker Desktop                                                               https://docs.docker.com/reference/
  echo ">>>> Docker Version"
  echo
  docker version
  echo

  echo ">>>> Docker Info"
  echo
  docker info
  echo

  # >>>> Docker - Process
  docker ps -a | grep -i ${PROJECT_NAME}
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Docker Desktop - docker-compose
    echo ">>>> checking docker compose"
    echo
    docker compose -f "postgresql-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "postgresql-compose.${ENVIRONMENT_NAME}.env" config
    echo

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Docker Desktop - docker-compose
    echo ">>>> checking docker compose"
    echo
    docker compose -f "postgresql-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "postgresql-compose.${ENVIRONMENT_NAME}.env" config
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Docker Desktop - docker-compose
    echo ">>>> checking docker compose"
    echo
    docker compose -f "postgresql-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "postgresql-compose.${ENVIRONMENT_NAME}.env" config
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
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
# Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
setPhp

# >>>> Cache
setRedis

# >>>> Database
setPostgreSQL

# >>>> Server
setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# >>>> End
setEnd
