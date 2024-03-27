#!/bin/bash
# ======================================================================================================================
# Scripts - Windows - Desktop - Deploy
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
  # >>>> Select one of some environments
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

# >>>> Platform

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Windows" ]; then
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    echo

    # >>>> Release
    echo ">>>> Release"
    ver
    echo

  else
    echo "Please check Operating System"
    setExit
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
  echo

  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/windows/desktop/etc/php/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/windows/desktop/etc/php/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/windows/desktop/etc/php/_install.sh" && exit
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
  echo

  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/windows/desktop/etc/redis/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/windows/desktop/etc/redis/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/windows/desktop/etc/redis/_install.sh" && exit
  fi
  echo
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

  # >>>> PHP - Symfony - Server
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_server.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_server.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_server.sh" && exit
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

  # >>>> AWS - Import a CLI file
  if [ -f ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh ]; then
    source ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh" && exit
  fi
  echo

  # >>>> AWS - Import a Config file
  if [ -f ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh ]; then
    source ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh" && exit
  fi
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
  if [ "${PLATFORM_TYPE}" == "Windows" ]; then
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

    # >>>> var/log/database
    if [ ! -d var/log/database ]; then
      mkdir -p var/log/database
    fi
    if [ ! -d var/log/database/postgres ]; then
      mkdir -p var/log/database/postgres
    fi
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Docker
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Docker Desktop - symfony-compose
  if [ -f ${PROJECT_PATH}/scripts/windows/desktop/etc/postgresql-compose.${ENVIRONMENT_NAME}.yml ]; then
    echo ">>>> Docker Desktop - checking docker compose"
    echo
    cp -fv ${PROJECT_PATH}/scripts/windows/desktop/etc/postgresql-compose.${ENVIRONMENT_NAME}.* ${PROJECT_PATH}
    echo
  fi

  # >>>> Docker Desktop - docker-compose
  if [ -f ${PROJECT_PATH}/postgresql-compose.${ENVIRONMENT_NAME}.yml ]; then
    echo ">>>> Docker Desktop - starting docker compose"
    echo

    local CURRENT_TIME
    CURRENT_TIME=$(date +%s)
    docker compose -f "postgresql-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "postgresql-compose.${ENVIRONMENT_NAME}.env" build --build-arg DISABLE_CACHE_PHP_DOCKERFILE=${CURRENT_TIME}
    echo

    docker compose -f "postgresql-compose.${ENVIRONMENT_NAME}.yml" --env-file ".env" --env-file "postgresql-compose.${ENVIRONMENT_NAME}.env" up --pull always -d
    echo

  else
    echo "There is not postgresql-compose.${ENVIRONMENT_NAME}.yml"
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
