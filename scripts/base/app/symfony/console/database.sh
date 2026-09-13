#!/bin/bash

#set -euo pipefail
# ----------------------------------------------------------------------------------------------------------------------
# Scripts - Console - App - Symfony - Console Commands - Database Migrations
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
  echo

  # >>>> Import a project file
  if [ -f "${PROJECT_PATH}"/scripts/base/_environment.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/_environment.sh
  else
    echo "Please check a file : ./scripts/base/_environment.sh" && exit
  fi
}

# >>>> Platform

setPlatform() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Platform"
  echo -e "----------------------------------------------------------------------------------------------------------\n"
}

# >>>> Project

setProject() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Project : ${PROJECT_NAME}"
  echo -e "----------------------------------------------------------------------------------------------------------\n"
}

# ----------------------------------------------------------------------------------------------------------------------
# Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - App - Packages"
  echo -e "----------------------------------------------------------------------------------------------------------\n"

  # >>>> Migrate
  if [ -d app ]; then
    (
      cd app || return
      # >>>> PHP - Symfony Command
      if [ -f bin/console ]; then

        # >>>> Select one of some environments
        PS3="Menu: "
        select num in "clear" "create" "update" "migrate" "validate" "status" "exit"; do
          case "${REPLY}" in
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

        # --------------------------------------------------------------------------------------------------------------
        # 1) Clear
        # --------------------------------------------------------------------------------------------------------------
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

        # --------------------------------------------------------------------------------------------------------------
        # 2) Create
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "create" ]; then

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Base
          # ------------------------------------------------------------------------------------------------------------

          echo ">>>> Updating the Database Tables/Schema - Base"
          echo

          symfony console doctrine:database:create -c base
          echo
          sleep 5

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Company
          # ------------------------------------------------------------------------------------------------------------

          echo ">>>> Updating the Database Tables/Schema - Company"
          echo

          symfony console doctrine:database:create -c company
          echo
          sleep 5

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Partners
          # ------------------------------------------------------------------------------------------------------------

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Products
          # ------------------------------------------------------------------------------------------------------------

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Providers
          # ------------------------------------------------------------------------------------------------------------

          echo ">>>> Updating the Database Tables/Schema - Providers - Finance - App - Agencies - ECOS"
          echo

          symfony console doctrine:database:create -c providers_finance_app_agencies_ecos
          echo
          sleep 5

          echo ">>>> Updating the Database Tables/Schema - Providers - Finance - App - Agencies - KOSIS"
          echo

          symfony console doctrine:database:create -c providers_finance_app_agencies_kosis
          echo
          sleep 5

          echo ">>>> Updating the Database Tables/Schema - Providers - Finance - App - Digital Asset - UPbit"
          echo

          symfony console doctrine:database:create -c providers_finance_app_digitalasset_upbit
          echo
          sleep 5

          symfony console doctrine:database:create -c providers_finance_app_digitalasset_upbit_domestic
          echo
          sleep 5

          echo ">>>> Updating the Database Tables/Schema - Providers - Finance - App - Securities - Korea Investment"
          echo

          symfony console doctrine:database:create -c providers_finance_app_securities_koreainvestment
          echo
          sleep 5

          symfony console doctrine:database:create -c providers_finance_app_securities_koreainvestment_domestic
          echo
          sleep 5

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Resources
          # ------------------------------------------------------------------------------------------------------------

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Team
          # ------------------------------------------------------------------------------------------------------------

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Tools
          # ------------------------------------------------------------------------------------------------------------

          echo ">>>> Updating the Database Tables/Schema - Tools"
          echo

          symfony console doctrine:database:create -c tools
          echo
          sleep 5

        # --------------------------------------------------------------------------------------------------------------
        # 3) Update
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "update" ]; then

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Base
          # ------------------------------------------------------------------------------------------------------------

          echo ">>>> Updating the Database Tables/Schema - Base"
          echo

          symfony console doctrine:schema:update --em base --force
          echo
          sleep 5

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Company
          # ------------------------------------------------------------------------------------------------------------

          echo ">>>> Updating the Database Tables/Schema - Company"
          echo

          symfony console doctrine:schema:update --em company --force
          echo
          sleep 5

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Partners
          # ------------------------------------------------------------------------------------------------------------

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Products
          # ------------------------------------------------------------------------------------------------------------

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Providers - APAC
          # ------------------------------------------------------------------------------------------------------------

          echo ">>>> Updating the Database Tables/Schema - Providers - Finance - App - Agencies - ECOS"
          echo

          symfony console doctrine:schema:update --em providers_finance_app_agencies_ecos --force
          echo
          sleep 5

          echo ">>>> Updating the Database Tables/Schema - Providers - Finance - App - Agencies - KOSIS"
          echo

          symfony console doctrine:schema:update --em providers_finance_app_agencies_kosis --force
          echo
          sleep 5

          echo ">>>> Updating the Database Tables/Schema - Providers - Finance - App - Digital Asset - UPbit"
          echo

          symfony console doctrine:schema:update --em providers_finance_app_digitalasset_upbit --force
          echo
          sleep 5

          symfony console doctrine:schema:update --em providers_finance_app_digitalasset_upbit_domestic --force
          echo
          sleep 5

          echo ">>>> Updating the Database Tables/Schema - Providers - Finance - App - Securities - Korea Investment"
          echo

          symfony console doctrine:schema:update --em providers_finance_app_securities_koreainvestment --force
          echo
          sleep 5

          symfony console doctrine:schema:update --em providers_finance_app_securities_koreainvestment_domestic --force
          echo
          sleep 5

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Resources
          # ------------------------------------------------------------------------------------------------------------

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Team
          # ------------------------------------------------------------------------------------------------------------

          # ------------------------------------------------------------------------------------------------------------
          # >>>> Tools
          # ------------------------------------------------------------------------------------------------------------

          echo ">>>> Updating the Database Tables/Schema - Tools"
          echo

          symfony console doctrine:schema:update --em tools --force
          echo
          sleep 5

        # --------------------------------------------------------------------------------------------------------------
        # 4) Migrate
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "migrate" ]; then
          echo ">>>> Updating the Database Tables/Schema"
          echo

          symfony console doctrine:migration:current
          #symfony console doctrine:migration:diff --allow-empty-diff --from-empty-schema
          echo
          sleep 5

          echo ">>>> Updating the Database Tables/Schema"
          echo

          symfony console make:migration
          echo
          sleep 5

          echo ">>>> Updating the Database Tables/Schema"
          echo

          symfony console doctrine:migration:migrate --no-interaction
          echo
          sleep 5

        # --------------------------------------------------------------------------------------------------------------
        # 5) Validate
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "validate" ]; then
          echo ">>>> Updating the Database Tables/Schema"
          echo

          symfony console doctrine:schema:validate
          echo

        # --------------------------------------------------------------------------------------------------------------
        # 6) Status
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${DOCTRINE_COMMAND}" == "status" ]; then
          echo ">>>> Updating the Database Tables/Schema"
          echo

          symfony console doctrine:migrations:status
        fi
        echo

        echo ">>>> Migrations: Check a list"
        echo

        symfony console doctrine:migration:list
        echo

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
}

# >>>> Server

setNginx() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Server - Packages"
  echo -e "----------------------------------------------------------------------------------------------------------\n"
}

# ----------------------------------------------------------------------------------------------------------------------
# Build Scripts
# ----------------------------------------------------------------------------------------------------------------------

setBuild() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Build"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Docker - Containers"
  echo "---------------------------------------------------------------------------------------------------------------"
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
# Utility
# ----------------------------------------------------------------------------------------------------------------------

setUtility() {
  echo -e "----------------------------------------------------------------------------------------------------------"
  echo -e "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Utility"
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
# Build Scripts
# ----------------------------------------------------------------------------------------------------------------------
#setBuild

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------
#setDocker

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
