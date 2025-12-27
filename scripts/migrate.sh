#!/bin/bash
# ======================================================================================================================
# Tools - IDE - Migrate databases
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$0")")
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
}

# >>>> Project

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${PROJECT_NAME}"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Migrate
  if [ -d app ]; then
    (
      cd app || return

      if [ -f bin/console ]; then

        # >>>> Select one of some environments
        PS3="Menu: "
        select num in "clear" "create" "update" "migrate" "validate" "status" "exit"; do
          case "$REPLY" in
          1)
            DOCTRINE_COMMAND="clear"
            break
            ;;
          2)
            DOCTRINE_COMMAND="create"
            break
            ;;
          3)
            DOCTRINE_COMMAND="update"
            break
            ;;
          4)
            DOCTRINE_COMMAND="migrate"
            break
            ;;
          5)
            DOCTRINE_COMMAND="validate"
            break
            ;;
          6)
            DOCTRINE_COMMAND="status"
            break
            ;;
          7)
            echo "exit()"
            exit
            ;;
          *)
            echo "[ ERROR ] Unknown Command"
            exit
            ;;
          esac
        done
        echo

        # ----------------------------------------------------------------------------------------------------------------
        # 1) Clear
        # ----------------------------------------------------------------------------------------------------------------
        if [ "${DOCTRINE_COMMAND}" == "clear" ]; then
          echo ">>>> Clear: Remove migrations files"
          echo

          if [ -d migrations ]; then
            rm -rfv migrations/*
          fi
          echo

          echo ">>>> Clear: Update the current schema into a new single migration"
          echo

          symfony console doctrine:migrations:dump-schema
          echo

          echo ">>>> Clear: Clean Up the Database Tables/Schema"
          echo

          symfony console doctrine:migrations:rollup
          echo

        # ----------------------------------------------------------------------------------------------------------------
        # 2) Create
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "create" ]; then
          echo ">>>> Create: Updating the Database Tables/Schema - Default"
          echo

          symfony console doctrine:database:create -c default

          sleep 5

        # ----------------------------------------------------------------------------------------------------------------
        # 3) Schema
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "update" ]; then
          echo ">>>> Update: Updating the Database Tables/Schema - Default"
          echo

          symfony console doctrine:schema:update --em default --force

          sleep 5

        # ----------------------------------------------------------------------------------------------------------------
        # 4) Migrate
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "migrate" ]; then
          echo ">>>> Migrate: Updating the Database Tables/Schema"
          echo

          symfony console doctrine:migration:current
          #symfony console doctrine:migration:diff --allow-empty-diff --from-empty-schema
          echo

          sleep 5

          echo ">>>> Migrate: Updating the Database Tables/Schema"
          echo

          symfony console make:migration
          echo

          sleep 5

          echo ">>>> Migrate: Updating the Database Tables/Schema"
          echo

          symfony console doctrine:migration:migrate
          echo

          sleep 5

        # ----------------------------------------------------------------------------------------------------------------
        # 5) Validate
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "validate" ]; then
          echo ">>>> Check: Updating the Database Tables/Schema - Default"
          echo

          symfony console doctrine:schema:validate
          echo

        # ----------------------------------------------------------------------------------------------------------------
        # 6) Status
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "status" ]; then
          echo ">>>> Status: Checking the Database Tables/Schema"
          echo

          symfony console doctrine:migrations:status
        fi
        echo

        echo ">>>> Migrations: Check a list"
        echo

        symfony console doctrine:migration:list

      else
        echo "[ ERROR ] There is not a command : app/bin/console"
        exit
      fi
    )
  else
    echo "[ ERROR ] There is not a folder : app"
    setExit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
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
}

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
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
#setDocker

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------
#setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
