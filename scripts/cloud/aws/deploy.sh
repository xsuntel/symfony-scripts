#!/bin/bash
# ======================================================================================================================
# Scripts - Cloud - AWS - Compute - Deploy
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
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
  # >>>> Select one of some environments
  PS3="Menu: "
  select num in "prod" "exit"; do
    case "$REPLY" in
    1)
      # >>>> Prod Environment
      ENVIRONMENT_NAME="prod"
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

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    echo

    # >>>> Release
    if [ -f /etc/lsb-release ]; then
      echo ">>>> Release"
      cat /etc/lsb-release
      echo

      sudo apt list --upgradable
      sudo apt update -y
      sudo apt upgrade -y
    fi

    # >>>> Install required packages
    local addPackageList="make acl curl git wget unzip"
    for pkgItem in ${addPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
        sudo apt install -y ${pkgItem}
        echo
      fi
    done

    # >>>> Remove additional packages
    if [ -f /etc/needrestart/needrestart.conf ]; then
      sudo apt purge -y needrestart
    fi
    echo

    # >>>> TimeZone
    sudo ls -l /etc/localtime
    if [ -f /usr/share/zoneinfo/${PLATFORM_TIMEZONE} ]; then
      sudo ln -snf /usr/share/zoneinfo/${PLATFORM_TIMEZONE} /etc/localtime
    fi
    timedatectl
    echo

    # >>>> Rsyslog
    local RSYSLOG_STATUS
    RSYSLOG_STATUS=$(systemctl is-active rsyslog)
    if [ "${RSYSLOG_STATUS}" == "active" ]; then
      echo ${RSYSLOG_STATUS}
    else
      sudo apt-get install -y rsyslog
      sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/etc/rsyslog.conf /etc/rsyslog.conf
      sudo systemctl restart rsyslog
    fi
    echo

    # >>>> Supervisor
    local SUPERVISOR_STATUS
    SUPERVISOR_STATUS=$(systemctl is-active supervisor)
    if [ "${SUPERVISOR_STATUS}" == "active" ]; then
      # >>>> conf.d/messenger-worker.conf
      sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/etc/supervisor/conf.d/messenger-worker.conf /etc/supervisor/conf.d/messenger-worker.conf
      echo
      sudo supervisorctl reread
    else
      sudo apt-get install -y supervisor
    fi
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
}

# >>>> Project

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${PROJECT_NAME}"
  echo

  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi
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

  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/etc/php/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/etc/php/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/etc/php/_install.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony - Command Line Interface
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_command.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_command.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_command.sh" && exit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/etc/redis/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/etc/redis/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/etc/redis/_install.sh" && exit
  fi
  echo

  # >>>> Delete logs files
  if [ -f /var/log/redis/redis-server.log.1.gz ]; then
    sudo rm -fv /var/log/redis/redis-server.log.*.gz
    echo
  fi
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - PostgreSQL"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server - Nginx"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/etc/nginx/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/etc/nginx/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/etc/nginx/_install.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony - Deployment
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony - Setting up or Fixing File Permissions - https://symfony.com/doc/current/setup/file_permissions.html
  (
    cd app || return

    HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"

    sudo setfacl -dR -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var
    sudo setfacl -R -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var


    sudo usermod -a -G "${HTTPDUSER}" "$(whoami)"
    sudo chown "${HTTPDUSER}":"${HTTPDUSER}" -R ./*
    sudo chmod 777 -R ./var
  )

  # >>>> Delete logs files
  if [ -f /var/log/nginx/www_access.log.1 ]; then
    sudo rm -fv /var/log/nginx/www_access.log.*
    echo
  fi

  # >>>> Delete logs files
  if [ -f /var/log/nginx/www_error.log.1 ]; then
    sudo rm -fv /var/log/nginx/www_error.log.*
    echo
  fi
}


# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Cloud"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> AWS - Import a CLI file
  if [ -f ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh ]; then
    source ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh" && exit
  fi
  echo

  # >>>> AWS - Import a CDN file
  if [ -f ${PROJECT_PATH}/scripts/cloud/aws/content_delivery/_s3.sh ]; then
    source ${PROJECT_PATH}/scripts/cloud/aws/content_delivery/_s3.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/content_delivery/_s3.sh"
    exit
  fi
  echo
}

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

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
#setPostgreSQL

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
#setDocker

# >>>> End
setEnd
