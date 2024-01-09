#!/bin/bash
# ======================================================================================================================
# Scripts - Docker - Containers - Migrate
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
}

# ----------------------------------------------------------------------------------------------------------------------
# Project
# ----------------------------------------------------------------------------------------------------------------------

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${ABSTRACT_NAME}"

  PS3="Menu: "
  select num in "clear" "create" "migrate" "update" "exit"; do
    case "$REPLY" in
    1)
      DOCTRINE_MIGRATIONS="clear"
      break
      ;;
    2)
      DOCTRINE_MIGRATIONS="create"
      break
      ;;
    3)
      DOCTRINE_MIGRATIONS="migrate"
      break
      ;;
    4)
      DOCTRINE_MIGRATIONS="update"
      break
      ;;
    5)
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

# ----------------------------------------------------------------------------------------------------------------------
# App
# ----------------------------------------------------------------------------------------------------------------------

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Docker Containers - PostgreSQL
  local DOCKER_CONTAINER_POSTGRES_STATUS
  DOCKER_CONTAINER_POSTGRES_STATUS=$(docker container ls | awk "/${ABSTRACT_NAME}_postgres_in_${ENVIRONMENT_NAME}/" | awk '{print $7; exit}')
  if [ "${DOCKER_CONTAINER_POSTGRES_STATUS}" == "Up" ]; then

    # >>>> Doctrine Migrations
    if [ "${DOCTRINE_MIGRATIONS}" == "clear" ]; then
      (
        cd app || return

        echo ">>>> Clear: Remove migrations files"
        if [ -d migrations ]; then
          docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "rm -rfv migrations/*"
        fi
        echo

        echo ">>>> Clear: Update the current schema into a new single migration"
        docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:migrations:dump-schema"
        echo

        echo ">>>> Clear: Clean Up the Database Tables/Schema"
        docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:migrations:rollup"
        #docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:migrations:rollup --em=default"
      )
    elif [ "${DOCTRINE_MIGRATIONS}" == "create" ]; then
      (
        cd app || return

        echo ">>>> Create: Updating the Database Tables/Schema"
        docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:database:create -c default"
      )
    elif [ "${DOCTRINE_MIGRATIONS}" == "migrate" ]; then
      (
        cd app || return

        echo ">>>> Migrate: Updating the Database Tables/Schema"
        docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:migration:current"
        docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:migration:diff --allow-empty-diff --from-empty-schema"
        docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console make:migration"
        docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:migration:migrate"
      )
    elif [ "${DOCTRINE_MIGRATIONS}" == "update" ]; then
      (
        cd app || return

        echo ">>>> Update: Updating the Database Tables/Schema"
        docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:migrations:dump-schema --em=default"
      )
    fi
    echo

    echo ">>>> Migrations: Check a list"
    docker exec -it "${ABSTRACT_NAME}_php_in_${ENVIRONMENT_NAME}" sh -c "php bin/console doctrine:migration:list"
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
  # >>>> Docker - Process
  docker ps -a | grep -i ${ABSTRACT_NAME}
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
#setRedis

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
