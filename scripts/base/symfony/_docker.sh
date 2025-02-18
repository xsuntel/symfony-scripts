#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Docker
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Docker - Update a permission
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    if [ -f /var/run/docker.sock ]; then
      sudo usermod -a -G docker $USER
      sudo chmod 666 /var/run/docker.sock
    fi
  fi
  echo
elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  echo -n
elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows
  # --------------------------------------------------------------------------------------------------------------------
  echo -n
else
  echo "Please check Operating System"
  setExit
fi

# >>>> Project
PROJECT_NAME=$(basename "$(realpath ${PROJECT_PATH})")

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers - System - Volume (Bind)                                        https://docs.docker.com/reference/
# ----------------------------------------------------------------------------------------------------------------------

# >>>> docker-compose files
echo ">>>> Docker Desktop - Update configurations"
echo
if [ -f ${PROJECT_PATH}/scripts/docker/containers/docker-compose.${ENVIRONMENT_NAME}.env ] && [ -f ${PROJECT_PATH}/scripts/docker/containers/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
  cp -fv ${PROJECT_PATH}/scripts/docker/containers/docker-compose.${ENVIRONMENT_NAME}.* ${PROJECT_PATH}
  echo
fi

# >>>> docker containers
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