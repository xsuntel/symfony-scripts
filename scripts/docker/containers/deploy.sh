#!/bin/bash
# ======================================================================================================================
# Scripts - Docker - Containers - Deploy
# ======================================================================================================================
# >>>> Base
PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
cd "${PROJECT_PATH}" || exit
if [ -f ${PROJECT_PATH}/.env ]; then
  # >>>> Import .env file
  source ${PROJECT_PATH}/.env
  # >>>> Import a abstract file
  if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_abstract.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
  fi
else
  echo "Please check .env file : ${PROJECT_PATH}/.env" && exit
fi

# ----------------------------------------------------------------------------------------------------------------------
# Environment
# ----------------------------------------------------------------------------------------------------------------------

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE}"
  echo "---------------------------------------------------------------------------------------------------------------"
  PS3="Menu: "
  select num in "dev" "exit"; do
    case "$REPLY" in
    1)
      # >>>> DEV Environment
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

# ----------------------------------------------------------------------------------------------------------------------
# Platform
# ----------------------------------------------------------------------------------------------------------------------

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PLATFORM OS : ${PLATFORM_TYPE}"
  echo
  # --------------------------------------------------------------------------------------------------------------------
  # Scripts - Platform - Base
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Import a platform file
  if [ -f ${PROJECT_PATH}/scripts/base/_platform.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_platform.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_platform.sh" && exit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Project
# ----------------------------------------------------------------------------------------------------------------------

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${ABSTRACT_NAME}"
  echo -n
  # --------------------------------------------------------------------------------------------------------------------
  # Scripts - Project - Base
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# App
# ----------------------------------------------------------------------------------------------------------------------

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/vm/ubuntu/etc/php/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/vm/ubuntu/etc/php/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/vm/ubuntu/etc/php/_install.sh" && exit
    fi
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> PHP
    local PHP_PKG
    PHP_PKG=$(brew list | grep php)
    if [ "${PHP_PKG}" ]; then
      local CURRENT_PHP_VERSION
      CURRENT_PHP_VERSION=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
    else
      brew install php@${PHP_VERSION}
      echo
    fi
    php --version
    echo
    php --ini
    echo

    # >>>> PHP Extension - PECL - Redis
    local PECL_STATUS
    PECL_STATUS=$(pecl list | awk '/redis/ {print $0}' | cut -c 1-6)
    if [ ${PECL_STATUS} ]; then
      pecl list redis
    else
      export LC_CTYPE=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      pecl install redis
    fi
    echo
    echo "extension-dir : $(php-config --extension-dir)"
    echo

    # >>>> PHP - Composer
    local PHP_COMPOSER
    PHP_COMPOSER=$(brew list | grep composer)
    if [ "${PHP_COMPOSER}" ]; then
      echo "Composer  : $(composer --version)"
    else
      brew install composer
    fi
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> PHP
    echo -n

  else
    echo "Please check Operating System"
    setExit
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # App - PHP - Symfony Framework - Deployment
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Import a symfony_deployment file
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Cache
# ----------------------------------------------------------------------------------------------------------------------

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Import an install file
    if [ -f ${PROJECT_PATH}/scripts/vm/ubuntu/etc/redis/_install.sh ]; then
      source ${PROJECT_PATH}/scripts/vm/ubuntu/etc/redis/_install.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/vm/ubuntu/etc/redis/_install.sh" && exit
    fi
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Redis
    local REDIS_PKG
    REDIS_PKG=$(brew list | grep redis)
    if [ "${REDIS_PKG}" ]; then
      brew services info redis
    else
      brew install redis
    fi
    echo

    brew services restart redis
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows - Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> PHP
    echo -n

  else
    echo "Please check Operating System"
    setExit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Database
# ----------------------------------------------------------------------------------------------------------------------

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - PostgreSQL"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Server
# ----------------------------------------------------------------------------------------------------------------------

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server - Nginx"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Scripts
# ----------------------------------------------------------------------------------------------------------------------

setCloud() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Cloud"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
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

  # >>>> Docker - Symfony Framework - recipes files
  if [ -f ${PROJECT_PATH}/app/docker-compose.yml ]; then
    echo ">>>> Symfony - deleted recipes files "
    find ${PROJECT_PATH}/app -name "docker-compose.yml" -exec rm -fv {} \;
    find ${PROJECT_PATH}/app -name "docker-compose.*.yml" -exec rm -fv {} \;
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Docker
  # --------------------------------------------------------------------------------------------------------------------
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
  else
    chmod 777 var
  fi

  # >>>> Docker Desktop - docker-compose
  echo ">>>> checking docker compose"
  echo
  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" build --no-cache
  else
    local CURRENT_TIME
    CURRENT_TIME=$(date +%s)
    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" build --build-arg DISABLE_CACHE_PHP_DOCKERFILE=${CURRENT_TIME}
  fi
  echo

  echo ">>>> starting docker compose"
  echo
  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" up --pull always -d
  else
    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" up --pull always -d
  fi
  echo

  echo ">>>> removing docker images"
  docker rmi $(docker images -f "dangling=true" -q --no-trunc)
  echo
}

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------

setGit() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - Git"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setIDE() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - IDE"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setWebBrowser() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - WebBrowser"
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
# >>>> App - PHP Framework - Symfony
# ----------------------------------------------------------------------------------------------------------------------
setPhp

# >>>> Cache
setRedis

# >>>> Database
#setPostgreSQL

# >>>> Server
#setNginx

# ----------------------------------------------------------------------------------------------------------------------
# >>>> Scripts
# ----------------------------------------------------------------------------------------------------------------------
#setCloud
setDocker
#setVM

# ----------------------------------------------------------------------------------------------------------------------
# >>>> Tools
# ----------------------------------------------------------------------------------------------------------------------
#setGit
#setIDE
#setWebBrowser

# >>>> End
setEnd
