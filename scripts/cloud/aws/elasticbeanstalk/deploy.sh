#!/bin/bash
# ======================================================================================================================
# Scripts - Cloud - AWS - Compute - Deploy
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
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/app/php/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/app/php/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/app/php/_install.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Command Line Interface
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_command.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_command.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_command.sh" && exit
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
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/cache/redis/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/cache/redis/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/cache/redis/_install.sh" && exit
  fi
  echo
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Message

setRabbitMQ() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Message"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> Nginx - Base - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/server/nginx/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/server/nginx/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/server/nginx/_install.sh" && exit
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
  echo

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_deployment.sh" && exit
  fi
  echo

  # >>>> AWS - Base - Import a CLI file
  #if [ -f ${PROJECT_PATH}/scripts/cloud/aws/elasticbeanstalk/_cli.sh ]; then
  #  source ${PROJECT_PATH}/scripts/cloud/aws/elasticbeanstalk/_cli.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/elasticbeanstalk/_cli.sh" && exit
  #fi
  #echo

  # >>>> AWS - Base - Import a CDN file
  #if [ -f ${PROJECT_PATH}/scripts/cloud/aws/elasticbeanstalk/_s3.sh ]; then
  #  source ${PROJECT_PATH}/scripts/cloud/aws/elasticbeanstalk/_s3.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/elasticbeanstalk/_s3.sh" && exit
  #fi
  #echo
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
# Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - VM - Instance"
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
  echo "REDIS      : ${REDIS_STATUS}"
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
    echo "PostgreSQL : ${POSTGRESQL_STATUS}"
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
  echo "NGINX      : ${NGINX_STATUS}"
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
#setPostgreSQL

# >>>> Message
#setRabbitMQ

# >>>> Server
setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------
setCDN

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
