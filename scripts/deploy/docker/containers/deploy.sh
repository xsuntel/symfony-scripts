#!/bin/bash
# ======================================================================================================================
# Scripts - Docker - Containers - Deploy
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

  # >>>> Import a platform file
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
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/app/php/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/macos/device/etc/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/macos/device/etc/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/macos/device/etc/php/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/windows/device/app/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/windows/device/app/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/windows/device/app/php/_install.sh" && exit
    fi

  else
    echo "Please check Operating System"
    setExit
  fi

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
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/cache/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/cache/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/cache/redis/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/macos/ubuntu/cache/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/macos/ubuntu/cache/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/macos/ubuntu/cache/redis/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/windows/ubuntu/cache/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/windows/ubuntu/cache/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/windows/ubuntu/cache/redis/_install.sh" && exit
    fi

  else
    echo "Please check Operating System"
    setExit
  fi
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
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/message/rabbitmq/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/message/rabbitmq/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/linux/ubuntu/message/rabbitmq/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/macos/ubuntu/message/rabbitmq/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/macos/ubuntu/message/rabbitmq/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/macos/ubuntu/message/rabbitmq/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/windows/ubuntu/message/rabbitmq/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/windows/ubuntu/message/rabbitmq/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/windows/ubuntu/message/rabbitmq/_install.sh" && exit
    fi

  else
    echo "Please check Operating System"
    setExit
  fi
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"
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
}

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Docker - Containers"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Docker Desktop - containers
  if [ -f ${PROJECT_PATH}/scripts/base/symfony/_docker.sh ]; then
    source ${PROJECT_PATH}/scripts/base/symfony/_docker.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/symfony/_docker.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - VM - Instance"
  echo "---------------------------------------------------------------------------------------------------------------"
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
setRabbitMQ

# >>>> Server
#setNginx

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
#setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
