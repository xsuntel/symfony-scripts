#!/bin/bash
# ======================================================================================================================
# Scripts - Docker - Containers - Deploy
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

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Environment"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> OS
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

  # >>>> OS
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

  # >>>> Git
  if [ -f ${PROJECT_PATH}/scripts/base/tools/_git.sh ]; then
    source ${PROJECT_PATH}/scripts/base/tools/_git.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/tools/_git.sh" && exit
  fi

  # >>>> Directory
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Bundles
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
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/app/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/app/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/app/php/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/macos/device/etc/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/macos/device/etc/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/macos/device/etc/php/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/windows/device/app/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/windows/device/app/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/windows/device/app/php/_install.sh" && exit
    fi

  else
    echo "Please check Operating System"
    setExit
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
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/cache/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/cache/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/cache/redis/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/macos/device/cache/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/macos/device/cache/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/macos/device/cache/redis/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/windows/device/cache/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/windows/device/cache/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/windows/device/cache/redis/_install.sh" && exit
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
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/message/rabbitmq/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/message/rabbitmq/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/message/rabbitmq/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/macos/device/message/rabbitmq/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/macos/device/message/rabbitmq/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/macos/device/message/rabbitmq/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/windows/device/message/rabbitmq/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/deploy/dev/windows/device/message/rabbitmq/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/windows/device/message/rabbitmq/_install.sh" && exit
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
# CDN - Content Delivery Networks
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - CDN - Content Delivery Networks"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Back-End - Permissions - Not required


  # >>>> PHP - Symfony Framework - Back-End - Database
  if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_database.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_database.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_database.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Back-End - Cron jobs
  if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_cron.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_cron.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_cron.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Back-End - Messenger
  if [ -f ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_messenger.sh ]; then
    source ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_messenger.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/back-end/_messenger.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Front-End - AssetMapper OR Webpack Encore
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
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Docker - Containers"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Docker
  if [ -f ${PROJECT_PATH}/scripts/base/tools/_docker.sh ]; then
    source ${PROJECT_PATH}/scripts/base/tools/_docker.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/tools/_docker.sh" && exit
  fi
  echo

  # >>>> Docker Desktop - docker-compose files
  echo ">>>> Docker Desktop - Update configurations"
  echo

  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/docker/containers/docker-compose.yml ]; then
    cp -fv ${PROJECT_PATH}/scripts/deploy/dev/docker/containers/docker-compose.yml ${PROJECT_PATH}
    echo
  fi

  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/docker/containers/docker-compose.${ENVIRONMENT_NAME}.env ] && [ -f ${PROJECT_PATH}/scripts/deploy/dev/docker/containers/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
    cp -fv ${PROJECT_PATH}/scripts/deploy/dev/docker/containers/docker-compose.${ENVIRONMENT_NAME}.* ${PROJECT_PATH}
    echo
  fi

  # >>>> Docker Desktop - docker containers
  if [ -f ${PROJECT_PATH}/docker-compose.yml ] && [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.env ] && [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
    echo ">>>> Docker Desktop - Build docker images"
    echo

    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
      docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env.base" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" build --no-cache
    else
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
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
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

# >>>> Environment
setEnvironment

# >>>> Platform
setPlatform

# >>>> Project
setProject

# ----------------------------------------------------------------------------------------------------------------------
# Bundles
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
# CDN - Content Delivery Networks
# ----------------------------------------------------------------------------------------------------------------------
setCDN

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
#setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
