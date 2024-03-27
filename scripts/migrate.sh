#!/bin/bash
# ======================================================================================================================
# Scripts - Project - Migrate
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
# Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Migrate
  if [ -d app ]; then
    (
      cd app || return

      # >>>> Symfony Framework
      if [ -f bin/console ]; then

        # >>>> Select one of some environments
        PS3="Menu: "
        select num in "clear" "create" "schema" "migrate" "status" "exit"; do
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
            DOCTRINE_COMMAND="schema"
            break
            ;;
          4)
            DOCTRINE_COMMAND="migrate"
            break
            ;;
          5)
            DOCTRINE_COMMAND="status"
            break
            ;;
          6)
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
        # >>>> Doctrine Migrations - (1) Clear
        # ----------------------------------------------------------------------------------------------------------------
        if [ "${DOCTRINE_COMMAND}" == "clear" ]; then
          echo ">>>> Clear: Remove migrations files"
          if [ -d migrations ]; then
            rm -rfv migrations/*
          fi
          echo

          echo ">>>> Clear: Update the current schema into a new single migration"
          php bin/console doctrine:migrations:dump-schema
          echo

          echo ">>>> Clear: Clean Up the Database Tables/Schema"
          php bin/console doctrine:migrations:rollup

        # ----------------------------------------------------------------------------------------------------------------
        # >>>> Doctrine Migrations - (2) Create
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "create" ]; then
          echo ">>>> Create: Updating the Database Tables/Schema"
          php bin/console doctrine:database:create -c default

        # ----------------------------------------------------------------------------------------------------------------
        # >>>> Doctrine Migrations - (3) Schema
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "schema" ]; then
          echo ">>>> Create: Updating the Database Tables/Schema"
          php bin/console doctrine:schema:update --force -em default

        # ----------------------------------------------------------------------------------------------------------------
        # >>>> Doctrine Migrations - (4) Migrate
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "migrate" ]; then
          echo ">>>> Migrate: Updating the Database Tables/Schema"
          php bin/console doctrine:migration:current
          echo

          echo ">>>> Migrate: Updating the Database Tables/Schema"
          php bin/console make:migration
          echo

          echo ">>>> Migrate: Updating the Database Tables/Schema"
          php bin/console doctrine:migration:migrate

        # ----------------------------------------------------------------------------------------------------------------
        # >>>> Doctrine Migrations - (5) Status
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "status" ]; then
          echo ">>>> Status: Checking the Database Tables/Schema"
          php bin/console doctrine:migrations:status
        fi
        echo

        echo ">>>> Migrations: Check a list"
          php bin/console doctrine:migration:list

      else
        echo "[ ERROR ] There is not a command : app/bin/console"
        exit
      fi
    )
  else
    echo "[ ERROR ] There is not a folder : app"
    exit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
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
#setRedis

# >>>> Database
#setPostgreSQL

# >>>> Server
#setNginx

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
#setDocker

# >>>> End
setEnd
