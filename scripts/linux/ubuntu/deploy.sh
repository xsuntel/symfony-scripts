#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Deploy
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
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

# >>>> Dev Environment

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
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_command.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_command.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_command.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Front-End
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_frontend.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_frontend.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_frontend.sh" && exit
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
  echo

  # >>>> PostgreSQL - Base - Import an install file
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/database/postgresql/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/database/postgresql/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/database/postgresql/_install.sh" && exit
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
  #if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/message/rabbitmq/_install.sh ]; then
  #  source ${PROJECT_PATH}/scripts/linux/ubuntu/message/rabbitmq/_install.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/message/rabbitmq/_install.sh" && exit
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
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - CDN"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh" && exit
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

# ----------------------------------------------------------------------------------------------------------------------
# Instance - Ubuntu
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
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

  # >>>> Import a services file
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_process.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_process.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_process.sh" && exit
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
