#!/bin/bash
# ======================================================================================================================
# Scripts - Project - Directories
# ======================================================================================================================

# >>>> Docker Project Name
PROJECT_NAME=$(basename "$(realpath ${PROJECT_PATH})")

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # ------------------------------------------------------------------------------------------------------------------
  # Platform - Linux
  # ------------------------------------------------------------------------------------------------------------------
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
  # Platform - MacOS
  # ------------------------------------------------------------------------------------------------------------------
  echo
elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # ------------------------------------------------------------------------------------------------------------------
  # Platform - Windows
  # ------------------------------------------------------------------------------------------------------------------
  echo
else
  echo "Please check Operating System"
  setExit
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

  # >>>> var/log/message
  if [ ! -d var/log/message ]; then
    mkdir -p var/log/message
  fi
  if [ ! -d var/log/message/rabbitmq ]; then
    mkdir -p var/log/message/rabbitmq
  fi

  # >>>> var/log/server
  if [ ! -d var/log/server ]; then
    mkdir -p var/log/server
  fi
  if [ ! -d var/log/server/nginx ]; then
    mkdir -p var/log/server/nginx
  fi
fi

# >>>> Docker Desktop - docker-compose files
echo ">>>> Docker Desktop - Update configurations"
echo
if [ -f ${PROJECT_PATH}/scripts/docker/containers/docker-compose.${ENVIRONMENT_NAME}.env ] && [ -f ${PROJECT_PATH}/scripts/docker/containers/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
  # >>>> Environment
  cp -fv ${PROJECT_PATH}/scripts/docker/containers/docker-compose.${ENVIRONMENT_NAME}.* ${PROJECT_PATH}
  echo
fi

# >>>> Docker Desktop - docker containers
if [ -f ${PROJECT_PATH}/docker-compose.yml ] && [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.env ] && [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
  echo ">>>> Docker Desktop - Build docker images"
  echo
  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env.app" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" build --no-cache
  else
    local CURRENT_TIME
    CURRENT_TIME=$(date +%s)
    docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env.app" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" build --build-arg DISABLE_CACHE_PHP_DOCKERFILE=${CURRENT_TIME}
  fi
  echo

  echo ">>>> Docker Desktop - Start docker containers"
  echo
  docker compose -f "docker-compose.yml" -f "docker-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env.app" --env-file "docker-compose.${ENVIRONMENT_NAME}.env" up --pull always -d
  echo

else
  echo "There is not docker-compose.${ENVIRONMENT_NAME}.yml"
  echo
fi