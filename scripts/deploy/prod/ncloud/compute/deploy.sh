#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Prod - NCloud - Compute - Ubuntu
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f "${PROJECT_PATH}/scripts/base/_abstract.sh" ]; then
  source "${PROJECT_PATH}/scripts/base/_abstract.sh"
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# >>>> Environment

if [ "${PLATFORM_TYPE}" != "Linux" ]; then
  echo
  echo "Please check Operating System"
  setExit
fi

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PLATFORM_TYPE} - ${PLATFORM_PROCESSOR}"
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
}

# >>>> Platform

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PLATFORM OS : ${PLATFORM_TYPE}"
  echo

  # >>>> Base
  if [ -f "${PROJECT_PATH}/scripts/base/_platform.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/_platform.sh"
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_platform.sh" && exit
  fi
}

# >>>> Project

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${PROJECT_NAME}"
  echo

  # >>>> Directory
  if [ -f "${PROJECT_PATH}/scripts/base/_project.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/_project.sh"
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Architecture - App - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP
  if [ -f "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/app/php/_install.sh ]; then
    source "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/app/php/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/app/php/_install.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Command Line Interface
  if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/_command.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/app/symfony/_command.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_command.sh" && exit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Architecture - Cache - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Redis
  if [ -f "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/cache/redis/_install.sh ]; then
    source "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/cache/redis/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/cache/redis/_install.sh" && exit
  fi
  echo
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Architecture - Database - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Message

setRabbitMQ() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Architecture - Message - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> RabbitMQ
  if [ -f "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/message/rabbitmq/_install.sh ]; then
    source "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/message/rabbitmq/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/message/rabbitmq/_install.sh" && exit
  fi
  echo
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Architecture - Server - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> Nginx
  if [ -f "${PROJECT_PATH}"/scripts/base/server/nginx/_install.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/server/nginx/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/server/nginx/_install.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------------------------------------------------

setBuild() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Build"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f "${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh"
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Permissions - (Optional)
  if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/back-end/_permissions.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/app/symfony/back-end/_permissions.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_permissions.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Database    - (Optional)
  #if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/back-end/_database.sh ]; then
  #  source "${PROJECT_PATH}"/scripts/base/app/symfony/back-end/_database.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_database.sh" && exit
  #fi
  #echo

  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Cron jobs   - (Optional)
  #if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/back-end/_cron.sh ]; then
  #  source "${PROJECT_PATH}"/scripts/base/app/symfony/back-end/_cron.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_cron.sh" && exit
  #fi
  #echo

  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Messenger   - (Optional)
  if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/back-end/_messenger.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/app/symfony/back-end/_messenger.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_messenger.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment - Front-End - AssetMapper - (Optional) OR Webpack Encore
  #if [ -f "${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh" ]; then
  #  source "${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh"
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh" && exit
  #fi
  #echo

  #if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/front-end/_webpack.sh ]; then
  #  source "${PROJECT_PATH}"/scripts/base/app/symfony/front-end/_webpack.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_webpack.sh" && exit
  #fi
  #echo
}

# ----------------------------------------------------------------------------------------------------------------------
# CDN ( Content Delivery Networks )
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - CDN ( Content Delivery Networks ) - Upload files"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Docker - Containers"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Providers ( Cloud Service Provider )
# ----------------------------------------------------------------------------------------------------------------------

setProvider() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Providers ( Cloud Service Provider )"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Utility
# ----------------------------------------------------------------------------------------------------------------------

setUtility() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - Utility"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# VM ( Instance )
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME^^} ] ${PLATFORM_TYPE} - VM ( Instance )"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  echo ">>>> Operating System"
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
  local REDIS_STATUS
  REDIS_STATUS=$(systemctl is-active redis)
  if [ "${REDIS_STATUS}" == "inactive" ]; then
    sudo systemctl start redis
    sudo systemctl status redis --no-pager
    echo
  fi
  echo "Cache      : ${REDIS_STATUS}"
  echo

  # >>>> Database
  local POSTGRESQL_STATUS
  POSTGRESQL_STATUS=$(systemctl is-active postgresql)
  if [ "${POSTGRESQL_STATUS}" == "inactive" ]; then
    sudo systemctl start postgresql
    sudo systemctl status postgresql --no-pager
    echo
  fi
  echo "PostgreSQL : ${POSTGRESQL_STATUS}"
  echo

  # >>>> Message
  local RABBITMQ_STATUS
  RABBITMQ_STATUS=$(systemctl is-active rabbitmq-server)
  if [ "${RABBITMQ_STATUS}" == "inactive" ]; then
    sudo systemctl start rabbitmq-server
    sudo systemctl status rabbitmq-server --no-pager
    echo
  fi
  echo "RabbitMQ : ${RABBITMQ_STATUS}"
  echo

  # >>>> Server
  local NGINX_STATUS
  NGINX_STATUS=$(systemctl is-active nginx)
  if [ "${NGINX_STATUS}" == "inactive" ]; then
    sudo systemctl start nginx
    sudo systemctl status nginx --no-pager
    echo
  fi
  echo "NGINX      : ${NGINX_STATUS}"
  echo
}

# ======================================================================================================================
# START
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
# Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
setPhp

# >>>> Cache
setRedis

# >>>> Database
#setPostgreSQL

# >>>> Message
#setRabbitMQ

# >>>> Server
setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------------------------------------------------
setBuild

# ----------------------------------------------------------------------------------------------------------------------
# CDN ( Content Delivery Networks )
# ----------------------------------------------------------------------------------------------------------------------
setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------
#setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Providers ( Cloud Service Provider )
# ----------------------------------------------------------------------------------------------------------------------
setProvider

# ----------------------------------------------------------------------------------------------------------------------
# Utility
# ----------------------------------------------------------------------------------------------------------------------
#setUtility

# ----------------------------------------------------------------------------------------------------------------------
# VM ( Instance )
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
