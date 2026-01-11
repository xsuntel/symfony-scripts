#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - MacOS - Device
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
  source ${PROJECT_PATH}/scripts/base/_abstract.sh
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# >>>> Environment

if [ "${PLATFORM_TYPE}" != "Darwin" ]; then
  echo
  echo "Please check Operating System"
  setExit
fi

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

  # >>>> Base
  if [ -f ${PROJECT_PATH}/scripts/base/_platform.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_platform.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_platform.sh" && exit
  fi

  # >>>> OS - Network
  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_network.sh ]; then
    source ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_network.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_network.sh" && exit
  fi
  echo

  # >>>> OS - Packages
  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_packages.sh ]; then
    source ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_packages.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_packages.sh" && exit
  fi
  echo

  # >>>> OS - Security
  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_security.sh ]; then
    source ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_security.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/macos/device/tools/_security.sh" && exit
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

  # >>>> Git
  if [ -f ${PROJECT_PATH}/tools/git/_config.sh ]; then
    source ${PROJECT_PATH}/tools/git/_config.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/tools/git/_config.sh" && exit
  fi

  # >>>> Directory
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
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
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP
  if [ -f ${PROJECT_PATH}/scripts/base/app/php/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/php/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/php/_install.sh" && exit
  fi

  # >>>> PHP - Symfony Framework - Command Line Interface
  if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/_command.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/symfony/_command.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_command.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Components
  if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/_components.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/symfony/_components.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_components.sh" && exit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Redis
  if [ -f ${PROJECT_PATH}/scripts/base/cache/redis/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/base/cache/redis/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/cache/redis/_install.sh" && exit
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
  echo

  # >>>> RabbitMQ
  if [ -f ${PROJECT_PATH}/scripts/base/message/rabbitmq/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/base/message/rabbitmq/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/message/rabbitmq/_install.sh" && exit
  fi
  echo
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------------------------------------------------

setBuild() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Build"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Permissions - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Database    - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Cron jobs   - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Messenger   - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Front-End - AssetMapper - (Optional) OR Webpack Encore
  #if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh ]; then
  #  source ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh" && exit
  #fi
  #echo

  #if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_webpack.sh ]; then
  #  source ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_webpack.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_webpack.sh" && exit
  #fi
  #echo
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
  echo

  # >>>> Docker
  if [ -f ${PROJECT_PATH}/scripts/containers/_docker.sh ]; then
    source ${PROJECT_PATH}/scripts/containers/_docker.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/containers/_docker.sh" && exit
  fi
  echo

  # >>>> Docker Desktop - docker-compose files
  echo ">>>> Docker Desktop - Update configurations"
  echo

  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/macos/device/tools/docker/docker-compose.yml ]; then
    cp -fv ${PROJECT_PATH}/scripts/deploy/dev/macos/device/tools/docker/docker-compose.yml ${PROJECT_PATH}
    echo
  fi

  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/macos/device/tools/docker/docker-compose.${ENVIRONMENT_NAME}.env ] && [ -f ${PROJECT_PATH}/scripts/deploy/dev/macos/device/tools/docker/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
    cp -fv ${PROJECT_PATH}/scripts/deploy/dev/macos/device/tools/docker/docker-compose.${ENVIRONMENT_NAME}.* ${PROJECT_PATH}
    echo
  fi

  # >>>> Docker Desktop - docker containers
  if [ -f ${PROJECT_PATH}/docker-compose.yml ] && [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.env ] && [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
    echo ">>>> Docker Desktop - Build docker images"
    echo

    local CURRENT_TIME
    CURRENT_TIME=$(date +%s)
    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env.base" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" build --build-arg DISABLE_CACHE_PHP_DOCKERFILE=${CURRENT_TIME}
    fi
    echo

    echo ">>>> Docker Desktop - Start docker containers"
    echo

    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env.base" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" up --pull always -d
    echo

  else
    echo "There is not docker-compose.${ENVIRONMENT_NAME}.yml"
    echo
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Provider - Cloud Service Provider
# ----------------------------------------------------------------------------------------------------------------------

setProvider() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Provider - Cloud Service Provider"
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

  # >>>> PHP - Symfony Framework - Server
  if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/_local_server.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/symfony/_local_server.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_local_server.sh" && exit
  fi
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Operating System
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> Operating System"
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Build
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> Software Bundles"
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
#setRedis

# >>>> Database
#setPostgreSQL

# >>>> Message
#setRabbitMQ

# >>>> Server
#setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------------------------------------------------
setBuild

# ----------------------------------------------------------------------------------------------------------------------
# CDN - Content Delivery Networks
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Provider - Cloud Service Provider
# ----------------------------------------------------------------------------------------------------------------------
#setProvider

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
