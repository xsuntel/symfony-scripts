#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Deploy
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

if [ "${PLATFORM_TYPE}" != "Linux" ]; then
  echo
  echo "Please check Operating System"
  setExit
fi

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

  # >>>> Import a platform file
  if [ -f ${PROJECT_PATH}/scripts/base/_platform.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_platform.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_platform.sh" && exit
  fi

  # >>>> Server - Network - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_network.sh ]; then
    source ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_network.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_network.sh" && exit
  fi
  echo

  # >>>> Server - Packages - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_packages.sh ]; then
    source ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_packages.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_packages.sh" && exit
  fi
  echo

  # >>>> Server - Security - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_security.sh ]; then
    source ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_security.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/develop/linux/ubuntu/tools/_security.sh" && exit
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

  # >>>> Project - Base - Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi

  # >>>> Project - Base - Symfony - Git
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_git.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_git.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_git.sh" && exit
  fi
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

  # >>>> PHP - Base - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/develop/linux/ubuntu/app/php/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/develop/linux/ubuntu/app/php/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/develop/linux/ubuntu/app/php/_install.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Command Line Interface
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_command.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_command.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_command.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Components
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_components.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_components.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_components.sh" && exit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Redis - Base - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/develop/linux/ubuntu/cache/redis/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/develop/linux/ubuntu/cache/redis/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/develop/linux/ubuntu/cache/redis/_install.sh" && exit
  fi
  echo
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PostgreSQL - Base - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/develop/linux/ubuntu/database/postgresql/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/develop/linux/ubuntu/database/postgresql/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/develop/linux/ubuntu/database/postgresql/_install.sh" && exit
  fi
  echo
}

# >>>> Message

setRabbitMQ() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Message"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> RabbitMQ - Base - Import an install file
  #if [ -f ${PROJECT_PATH}/scripts/develop/linux/ubuntu/message/rabbitmq/_install.sh ]; then
  #  source ${PROJECT_PATH}/scripts/develop/linux/ubuntu/message/rabbitmq/_install.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/develop/linux/ubuntu/message/rabbitmq/_install.sh" && exit
  #fi
  #echo
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Nginx - Base - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/develop/linux/ubuntu/server/nginx/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/develop/linux/ubuntu/server/nginx/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/develop/linux/ubuntu/server/nginx/_install.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - CDN - Content Delivery Networks"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Instance - Ubuntu
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Web Application"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP - Symfony Framework - Supervisor
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_supervisor.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_supervisor.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_supervisor.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Server
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_server.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_server.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_server.sh" && exit
  fi
  echo

  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - VM - Instance"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  echo ">>>> Process"
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
  echo
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
  echo "PHP-FPM    : ${PHP_STATUS}"
  echo

  # >>>> Cache
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

  # >>>> Database
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local POSTGRESQL_STATUS
    POSTGRESQL_STATUS=$(systemctl is-active postgresql)
    if [ "${POSTGRESQL_STATUS}" == "inactive" ]; then
      sudo systemctl start postgresql
      sudo systemctl status postgresql --no-pager
      echo
    fi
    echo "Database   : ${POSTGRESQL_STATUS}"
    echo
  fi

  # >>>> Message
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local RABBITMQ_STATUS
    RABBITMQ_STATUS=$(systemctl is-active rabbitmq-server)
    if [ "${RABBITMQ_STATUS}" == "inactive" ]; then
      sudo systemctl start rabbitmq-server
      sudo systemctl status rabbitmq-server --no-pager
      echo
    fi
    echo "Message    : ${RABBITMQ_STATUS}"
    echo
  fi

  # >>>> Server
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
#setRabbitMQ

# >>>> Server
setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------
#setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
