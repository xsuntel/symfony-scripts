#!/bin/bash
# ======================================================================================================================
# Scripts - App - Clear cache files
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$0")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f "${PROJECT_PATH}/scripts/base/_abstract.sh" ]; then
  source "${PROJECT_PATH}/scripts/base/_abstract.sh"
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# >>>> Environment

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Environment"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> OS
  if [ -f "${PROJECT_PATH}"/scripts/base/_environment.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/_environment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_environment.sh" && exit
  fi
}

# >>>> Platform

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PLATFORM OS : ${PLATFORM_TYPE}"
  echo
}

# >>>> Project

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${PROJECT_NAME}"
  echo

  # >>>> Directory
  if [ -d app ]; then
    (
      cd app || return

      # >>>> PHP - Symfony Command                                        https://symfony.com/doc/current/deployment.html
      if [ -f bin/console ]; then

        # >>>> public
        if [ -d public ]; then
          # >>>> public/assets
          if [ -d public/assets ]; then
            rm -rf public/assets/*
          fi
          # >>>> public/bundles
          if [ -d public/bundles ]; then
            rm -rf public/bundles/*
          fi
          # >>>> Remove related performance files
          if [ -f public/0.meta.json ]; then
            rm -f public/[0-9]
            rm -f public/[0-9].meta
            rm -f public/[0-9].meta.json
          fi
        fi

        # >>>> Remove cache files
        if [ -d var ]; then

          # >>>> Platform
          if [ "${PLATFORM_TYPE}" == "Linux" ]; then

            if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
              rm -rf var/*
              chmod 777 var
            else
              sudo rm -rf var/*
              sudo chmod 777 var
            fi
            mkdir -p var/cache
            mkdir -p var/log
            mkdir -p var/sessions
            mkdir -p var/translations

          elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then

            rm -rf var/*
            mkdir -p var/cache
            mkdir -p var/log
            mkdir -p var/sessions
            mkdir -p var/translations

          elif [ "${PLATFORM_TYPE}" == "Windows" ]; then

            rm -rf var/*
            mkdir -p var/cache
            mkdir -p var/log
            mkdir -p var/sessions
            mkdir -p var/translations

          else
            rm -rf var/*
          fi

        fi

        # >>>> php-cs-fixer
        if [ -f .php-cs-fixer.cache ]; then
          rm -f .php-cs-fixer.cache
        fi
      fi
    )
  else
    echo
    echo "[ ERROR ] There is not a folder : app"
    echo
    setExit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Directory
  if [ -d app ]; then
    (
      cd app || return
      # >>>> PHP - Symfony Command
      if [ -f bin/console ]; then

        # >>>> Environment
        if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

          echo ">>>> PHP - Symfony - Bundles - PHP-CS-Fixer"
          echo
          if [ -f ./vendor/bin/php-cs-fixer ]; then
            ./vendor/bin/php-cs-fixer fix ./src
          else
            composer require php-cs-fixer/shim --dev
          fi
          echo

          echo ">>>> PHP - Symfony - Bundles - Asset Mapper"
          echo
          symfony console importmap:outdated
          echo

          #symfony console importmap:update
          #echo
        fi
      fi
    )
  else
    echo "[ ERROR ] There is not a folder : app"
    setExit
  fi

  # >>>> PHP - Symfony Framework - php-cs-fixer
  if [ -f .php-cs-fixer.cache ]; then
    rm -f .php-cs-fixer.cache
  fi

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f "${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh"
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Permissions - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Database    - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Cron jobs   - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Messenger   - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Front-End - AssetMapper - (Optional)
  if [ -f "${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh"
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/front-end/_assetmapper.sh" && exit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Message

setRabbitMQ() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Message"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Build
# ----------------------------------------------------------------------------------------------------------------------

setBuild() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Build"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# CDN - Content Delivery Networks
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - CDN - Content Delivery Networks"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Docker - System
  echo ">>>> Docker - System"
  echo
  docker system df
  echo

  # >>>> Docker - Process
  echo ">>>> Docker - Process"
  echo
  docker ps -a
  echo

  # >>>> Docker - Images
  echo ">>>> Docker - images"
  echo

  docker image ls
  echo

  # >>>> Docker - Remove build cache
  echo ">>>> Docker - Remove build cache"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      docker image prune -a -f --filter "until=48h"
    fi
    echo

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      docker image prune -a -f --filter "until=48h"
    fi
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      docker image prune -a -f --filter "until=48h"
    fi
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${ENVIRONMENT_NAME^^} - ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - VM - Instance"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> App - PHP - Symfony Framework - Server
  if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/_local_server.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/app/symfony/_local_server.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/app/symfony/_local_server.sh" && exit
  fi
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
# CDN - Content Delivery Networks
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
