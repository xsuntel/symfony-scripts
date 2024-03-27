#!/bin/bash
# ======================================================================================================================
# Scripts - Docker - Containers - Deploy
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
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/etc/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/linux/ubuntu/etc/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/etc/php/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/macos/desktop/etc/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/macos/desktop/etc/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/macos/desktop/etc/php/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/windows/desktop/etc/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/windows/desktop/etc/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/windows/desktop/etc/php/_install.sh" && exit
    fi

  else
    echo "Please check Operating System"
    setExit
  fi

  # >>>> PHP - Symfony - Command Line Interface
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_command.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_command.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_command.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony - Front-End
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
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/etc/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/linux/ubuntu/etc/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/etc/redis/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/macos/ubuntu/etc/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/macos/ubuntu/etc/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/macos/ubuntu/etc/redis/_install.sh" && exit
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/windows/ubuntu/etc/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/windows/ubuntu/etc/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/windows/ubuntu/etc/redis/_install.sh" && exit
    fi

  else
    echo "Please check Operating System"
    setExit
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
  echo

  # >>>> PHP - Symfony - Deployment
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh" && exit
  fi
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
}

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    # >>>> Docker - Update a permission
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      sudo usermod -a -G docker $USER

      if [ -f /var/run/docker.sock ]; then
        sudo chmod 666 /var/run/docker.sock
      fi
    fi
    echo
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    echo
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    echo
  else
    echo "Please check Operating System"
    setEnd
  fi

  # >>>> Docker Desktop - System - Volume (Bind)                                      https://docs.docker.com/reference/
  if [ ! -d var ]; then
    mkdir -p var
    # >>>> var/log
    if [ ! -d var/log ]; then
      mkdir -p var/log
    fi

    # >>>> var/log/app
    if [ ! -d var/log/app ]; then
      mkdir -p var/log/app
    fi
    if [ ! -d var/log/app/php ]; then
      mkdir -p var/log/app/php
    fi

    # >>>> var/log/cache
    if [ ! -d var/log/cache ]; then
      mkdir -p var/log/cache
    fi
    if [ ! -d var/log/cache/redis ]; then
      mkdir -p var/log/cache/redis
    fi

    # >>>> var/log/database
    if [ ! -d var/log/database ]; then
      mkdir -p var/log/database
    fi
    if [ ! -d var/log/database/postgres ]; then
      mkdir -p var/log/database/postgres
    fi

    # >>>> var/log/server
    if [ ! -d var/log/server ]; then
      mkdir -p var/log/server
    fi
    if [ ! -d var/log/server/nginx ]; then
      mkdir -p var/log/server/nginx
    fi
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Docker
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Docker Desktop - symfony-compose
  if [ -f ${PROJECT_PATH}/scripts/docker/containers/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
    cp -fv ${PROJECT_PATH}/scripts/docker/containers/docker-compose.${ENVIRONMENT_NAME}.* ${PROJECT_PATH}
    cp -fv ${PROJECT_PATH}/scripts/docker/containers/docker-compose.yml ${PROJECT_PATH}
    echo
  fi

  # >>>> Docker Desktop - docker-compose
  if [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.yml ]; then

    echo ">>>> Docker Desktop - checking docker compose"
    echo
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
      docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" build --no-cache
    else
      local CURRENT_TIME
      CURRENT_TIME=$(date +%s)
      docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" build --build-arg DISABLE_CACHE_PHP_DOCKERFILE=${CURRENT_TIME}
    fi
    echo

    echo ">>>> Docker Desktop - starting docker compose"
    echo
    if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
      docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" up --pull always -d
    else
      docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" up --pull always -d
    fi
    echo

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
#setVM

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# >>>> End
setEnd
