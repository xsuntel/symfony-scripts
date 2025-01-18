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

  # >>>> Import a platform file : Firewall
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/_firewall.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/_firewall.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/_firewall.sh" && exit
  fi

  # >>>> Import a platform file : Hosts
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/_hosts.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/_hosts.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/_hosts.sh" && exit
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

  # >>>> PHP - Symfony Framework - Components
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_components.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_components.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_components.sh" && exit
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
  echo

  # >>>> Docker Desktop - a recipe file for Symfony
  if [ -f ${PROJECT_PATH}/app/docker-compose.yml ]; then
    echo ">>>> Docker - a recipe file for Symfony"
    rm -f ${PROJECT_PATH}/app/docker-compose.*
    echo
  fi

  # >>>> Docker Desktop - docker-compose files
  if [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.env ]; then
    rm -fv ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.env
  fi
  if [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
    rm -fv ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.yml
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Instance - Ubuntu
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Linux - Ubuntu - Status
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/_vm.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/_vm.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/_vm.sh" && exit
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
