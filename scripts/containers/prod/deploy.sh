#!/bin/bash

#set -euo pipefail
# ----------------------------------------------------------------------------------------------------------------------
# Scripts - Docker - Containers - Prod - Debug
# ----------------------------------------------------------------------------------------------------------------------

find_project_root() {
    local PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    while [[ "${PROJECT_DIR}" != "/" ]]; do
        if [[ -d "${PROJECT_DIR}/.git" ]] || [[ -f "${PROJECT_DIR}/.env.app" ]]; then
            echo "${PROJECT_DIR}"
            return 0
        fi
        PROJECT_DIR="$(dirname "${PROJECT_DIR}")"
    done
    return 1
}

PROJECT_PATH=$(find_project_root)
PROJECT_NAME=$(basename "$(realpath "${PROJECT_PATH}")")
cd "${PROJECT_PATH}" || exit

# ----------------------------------------------------------------------------------------------------------------------
# Abstract
# ----------------------------------------------------------------------------------------------------------------------

if [ -f "${PROJECT_PATH}/scripts/base/_abstract.sh" ]; then
  source "${PROJECT_PATH}/scripts/base/_abstract.sh"
else
  echo "Please check a file : ./scripts/base/_abstract.sh" && exit
fi

# >>>> Environment

setEnvironment() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ENV ] ${PLATFORM_TYPE} - ${PLATFORM_PROCESSOR}"
  echo -e "----------------------------------------------------------------------------------------------------------\n"
  # >>>> Select one of some environments
  PS3="Menu: "
  select num in "prod" "exit"; do
    case "${REPLY}" in
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
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Platform"
  echo -e "----------------------------------------------------------------------------------------------------------\n"

  # >>>> Base
  if [ -f "${PROJECT_PATH}/scripts/base/_platform.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/_platform.sh"
  else
    echo "Please check a file : ./scripts/base/_platform.sh" && exit
  fi
}

# >>>> Project

setProject() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Project : ${PROJECT_NAME}"
  echo -e "----------------------------------------------------------------------------------------------------------\n"

  # >>>> Directory
  if [ -f "${PROJECT_PATH}/scripts/base/_project.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/_project.sh"
  else
    echo "Please check a file : ./scripts/base/_project.sh" && exit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - App - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Cache

setRedis() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Cache - Packages"
  echo -e  "---------------------------------------------------------------------------------------------------------\n"
}

# >>>> Database

setPostgreSQL() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Database - Packages"
  echo -e "----------------------------------------------------------------------------------------------------------\n"
}

# >>>> Message

setRabbitMQ() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Message - Packages"
  echo -e "----------------------------------------------------------------------------------------------------------\n"
  echo
}

# >>>> Server

setNginx() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Server - Packages"
  echo -e "----------------------------------------------------------------------------------------------------------\n"
  echo

  # The container publishes ${DOCKERFILE_LOCALHOST_PORT} on the host; 8080 is the in-container
  # port and is never bound on the host. Freeing 8080 here released an unrelated process.
  local HOST_PORT
  HOST_PORT="${DOCKERFILE_LOCALHOST_PORT:?DOCKERFILE_LOCALHOST_PORT is not set — check .env.app}"

  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux
  # --------------------------------------------------------------------------------------------------------------------
  local LOCAL_LISTEN_PORT
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".${HOST_PORT}" | awk '{print $6}')
    if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
      sudo fuser -k "${HOST_PORT}/tcp"
    fi

  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Mac - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".${HOST_PORT}" | awk '{print $6}')
    if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
      local LISTEN_PIDS
      LISTEN_PIDS=$(lsof -ti:"${HOST_PORT}")
      if [ -n "${LISTEN_PIDS}" ]; then
        # Word splitting is intended: lsof -t emits one PID per line.
        # shellcheck disable=SC2086
        kill -9 ${LISTEN_PIDS}
      fi
    fi

  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows - WSL2
  # --------------------------------------------------------------------------------------------------------------------
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep "${HOST_PORT}" | awk '{print $6}')
    if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
      sudo fuser -k "${HOST_PORT}/tcp"
    fi

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Build Scripts
# ----------------------------------------------------------------------------------------------------------------------

setBuild() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Build"
  echo -e "----------------------------------------------------------------------------------------------------------\n"

  # >>>> PHP - Symfony Framework - .env.prod.local
  # The real file is untracked (secrets); .env.prod.local.dist is the committed template.
  if [ -f "./scripts/containers/prod/.env.prod.local" ]; then
    cp -fv "./scripts/containers/prod/.env.prod.local" ./app/.env.prod.local
  else
    echo "[ ERROR ] Missing file : ./scripts/containers/prod/.env.prod.local"
    echo "          cp ./scripts/containers/prod/.env.prod.local.dist ./scripts/containers/prod/.env.prod.local"
    echo "          then fill in the placeholder values."
    setExit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f "${PROJECT_PATH}/scripts/base/app/symfony/base/_deployment.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/app/symfony/base/_deployment.sh"
  else
    echo "Please check a file : ./scripts/base/app/symfony/base/_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Permissions - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Database    - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Cron jobs   - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Messenger   - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Front-End - AssetMapper - (Optional)
  if [ -f "${PROJECT_PATH}/scripts/base/app/symfony/config/assets/_assetmapper.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/app/symfony/config/assets/_assetmapper.sh"
  else
    echo "Please check a file : ./scripts/base/app/symfony/config/assets/_assetmapper.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Docker - Containers"
  echo -e "----------------------------------------------------------------------------------------------------------\n"

  echo ">>>> Docker - Container - App"
  echo

  CONTAINER_NAME="app-php-prod"
  if [ -n "$(docker ps -aq -f "name=^${CONTAINER_NAME}$")" ]; then
    docker stop "${CONTAINER_NAME}"
    docker rm -f "${CONTAINER_NAME}"
    echo
  fi

  echo ">>>> Docker - Network"
  echo

  # docker compose derives the project name from --project-directory, which _deploy.sh sets to
  # PROJECT_PATH — so the compose network is "<repo directory name>_back-end". Hardcoding it
  # broke `docker run` on every checkout whose directory name differed from the literal.
  DOCKER_NETWORK_NAME="${PROJECT_NAME}_back-end"
  if ! docker network inspect "${DOCKER_NETWORK_NAME}" > /dev/null 2>&1; then
    echo "[ ERROR ] Docker network not found : ${DOCKER_NETWORK_NAME}"
    echo "          Start the dev infrastructure stack first (redis / postgres / rabbitmq)."
    setExit
  fi
  echo "Network: ${DOCKER_NETWORK_NAME}"
  echo

  echo ">>>> Docker - Build"
  echo

  IMAGE_NAME=${DOCKERFILE_IMAGE_NAME:-"xsun-app-php"}
  # Date alone is mutable — two deployments on the same day overwrite each other and the
  # previous image can no longer be pinned for rollback. Append the commit SHA.
  TAG_NAME="$(date +%Y.%m.%d)-$(git -C "${PROJECT_PATH}" rev-parse --short HEAD 2> /dev/null || echo "nogit")"

  # >>>> PHP version drift check — the container runtime and the host can diverge onto different PHP.
  #
  # This build **deliberately does not pass** `--build-arg PHP_VERSION`. The image is based on the
  # official Docker `php:<X.Y>-fpm-alpine`, and that tag is published later than the Ubuntu package
  # (php<X.Y>-fpm). Pushing PHP_VERSION from `.env.app` straight through would pull a tag that does not
  # exist yet and break the build (as of 2026-09 the php:8.5-* tags are unpublished and only 8.4 exists).
  #
  # So the container version is owned by the ARG default in the Dockerfile — but it is **not left to
  # diverge silently**. A mismatch is surfaced by the warning below, and raising it means editing the
  # Dockerfile ARG (not passing an argument here).
  DOCKERFILE_PHP_VERSION=$(grep -m1 -E '^ARG PHP_VERSION=' "${PROJECT_PATH}/scripts/containers/prod/Dockerfile" | cut -d'"' -f2)

  echo "  >> PHP - host/.env.app : ${PHP_VERSION:-unset}"
  echo "  >> PHP - container ARG : ${DOCKERFILE_PHP_VERSION:-unset}"

  if [ -n "${PHP_VERSION:-}" ] && [ -n "${DOCKERFILE_PHP_VERSION}" ] && [ "${PHP_VERSION}" != "${DOCKERFILE_PHP_VERSION}" ]; then
    echo
    echo "  >> [WARN] The production container is built with a different PHP than the host (${DOCKERFILE_PHP_VERSION} vs ${PHP_VERSION})."
    echo "            Extension modules and deprecation behavior may diverge from dev. To raise it:"
    echo "            1) docker manifest inspect php:${PHP_VERSION}-fpm-alpine  to check the tag is published"
    echo "            2) edit ARG PHP_VERSION in scripts/containers/prod/Dockerfile"
  fi
  echo

  docker build -f "${PROJECT_PATH}/scripts/containers/prod/Dockerfile" --network=host -t "${IMAGE_NAME}:${TAG_NAME}" "${PROJECT_PATH}" --no-cache
  echo

  unset DOCKERFILE_PHP_VERSION

  echo ">>>> Docker - Run"
  echo

  # host-gateway is not resolvable by default on Linux; the diagnostics further down
  # (getent hosts host.docker.internal) assume this mapping exists.
  CONTAINER_ID=$(docker run -d \
    --cpus="4.0" \
    --memory="4g" \
    --net "${DOCKER_NETWORK_NAME}" \
    --add-host "host.docker.internal:host-gateway" \
    -p "127.0.0.1:${DOCKERFILE_LOCALHOST_PORT}:8080" \
    --name "${CONTAINER_NAME}" \
    "${IMAGE_NAME}:${TAG_NAME}")

  echo ">>>> Docker - Started Container ID: ${CONTAINER_ID}"
  echo

  echo ">>>> Docker - Wait for health check"
  echo

  # The image declares a HEALTHCHECK; probing it beats racing supervisord with `docker exec`.
  local HEALTH_STATUS
  local HEALTH_TRIES
  HEALTH_TRIES=0
  while [ "${HEALTH_TRIES}" -lt 30 ]; do
    HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "${CONTAINER_ID}" 2> /dev/null || echo "unknown")
    if [ "${HEALTH_STATUS}" == "healthy" ]; then
      break
    fi
    if [ "${HEALTH_STATUS}" == "unhealthy" ]; then
      echo "[ ERROR ] Container reported unhealthy"
      docker logs "${CONTAINER_ID}"
      setExit
    fi
    HEALTH_TRIES=$((HEALTH_TRIES + 1))
    sleep 2
  done

  # Falling out of the loop still "starting" means the 60s budget expired — treat it as a
  # failed deployment rather than continuing to run diagnostics against a broken container.
  if [ "${HEALTH_STATUS}" != "healthy" ]; then
    echo "[ ERROR ] Container did not become healthy within 60s (last status: ${HEALTH_STATUS})"
    docker logs "${CONTAINER_ID}"
    setExit
  fi
  echo "Health: ${HEALTH_STATUS}"
  echo

  echo ">>>> Docker - Process"
  echo
  docker ps --filter "id=${CONTAINER_ID}"
  echo

  echo ">>>> Docker - Container"
  echo

  docker container ls
  echo

  echo ">>>> Docker - Image"
  echo

  docker image ls
  echo

  docker image inspect "${IMAGE_NAME}:${TAG_NAME}"
  echo

  docker inspect "${CONTAINER_ID}" --format='{{.HostConfig.ExtraHosts}}'
  echo


  echo ">>>> Docker - Port"
  echo

  docker port "${CONTAINER_ID}"
  echo

  echo ">>>> Docker - Exec"
  echo

  # No -it here: this script runs non-interactively (and from CI), where -t fails outright.
  # The three piped calls below were doubly broken — a TTY-allocated exec cannot be piped.
  docker exec "${CONTAINER_ID}" ps aux
  echo

  docker exec "${CONTAINER_ID}" cat /etc/hosts | grep host.docker.internal
  echo

  docker exec "${CONTAINER_ID}" getent hosts host.docker.internal
  echo

  docker exec "${CONTAINER_ID}" netstat -tulpn | grep 8080
  echo

  echo ">>>> Docker - Exec - Supervisor"
  echo

  docker exec "${CONTAINER_ID}" supervisorctl status
  echo

  echo ">>>> Docker - Exec - App"
  echo

  docker exec "${CONTAINER_ID}" php /var/www/app/bin/console debug:dotenv
  echo

  echo ">>>> Docker - Exec - PHP-FPM"
  echo

  docker exec "${CONTAINER_ID}" php-fpm -t
  echo

  echo ">>>> Docker - Exec - Nginx"
  echo

  docker exec "${CONTAINER_ID}" nginx -t
  echo

  echo ">>>> Docker - Logs"
  echo

  docker logs "${CONTAINER_ID}"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Provider ( Cloud Service Providers )
# ----------------------------------------------------------------------------------------------------------------------

setProvider() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Provider ( Cloud Service Providers )"
  echo -e "----------------------------------------------------------------------------------------------------------\n"
}

# ----------------------------------------------------------------------------------------------------------------------
# Tools for VM ( Instance )
# ----------------------------------------------------------------------------------------------------------------------

setTools() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Tools for VM ( Instance )"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Utility
# ----------------------------------------------------------------------------------------------------------------------

setUtility() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Utility"
  echo -e "----------------------------------------------------------------------------------------------------------\n"

  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux
  # --------------------------------------------------------------------------------------------------------------------
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    echo ">>>> Process"
    echo

    pgrep -af docker
    echo

    echo ">>>> Network"
    echo

    netstat -nlp | grep "${DOCKERFILE_LOCALHOST_PORT}"
    echo

    echo ">>>> Port"
    echo

    # Host-published port, not the in-container 8080.
    curl -v "http://localhost:${DOCKERFILE_LOCALHOST_PORT}"
    echo

  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Mac - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    echo

  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows - WSL2
  # --------------------------------------------------------------------------------------------------------------------
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# START
# ----------------------------------------------------------------------------------------------------------------------

setStart

# ----------------------------------------------------------------------------------------------------------------------
# Abstract
# ----------------------------------------------------------------------------------------------------------------------

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
#setPhp

# >>>> Cache
#setRedis

# >>>> Database
#setPostgreSQL

# >>>> Message
#setRabbitMQ

# >>>> Server
setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Build Scripts
# ----------------------------------------------------------------------------------------------------------------------
setBuild

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Provider ( Cloud Service Providers )
# ----------------------------------------------------------------------------------------------------------------------
#setProvider

# ----------------------------------------------------------------------------------------------------------------------
# Tools for VM ( Instance )
# ----------------------------------------------------------------------------------------------------------------------
#setTools

# ----------------------------------------------------------------------------------------------------------------------
# Utility
# ----------------------------------------------------------------------------------------------------------------------
setUtility

# ----------------------------------------------------------------------------------------------------------------------
# END
# ----------------------------------------------------------------------------------------------------------------------

setEnd

