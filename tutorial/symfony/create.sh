#!/bin/bash
# ======================================================================================================================
# Tutorial - Create a new project
# ======================================================================================================================
# >>>> Base
PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
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
  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi

  # >>>> Delete a directory : ./app
  if [ -f app/bin/console ]; then
    echo
    echo "[ Warning ] Do you want to delete a current project  ? "
    echo
    PS3="Select: "
    select num in "No" "Yes"; do
      case "$REPLY" in
      1)
        echo "Please check your project whether symfony has been installed or not again"
        setEnd
        ;;
      2)
        sudo rm -rf app
        echo
        break
        ;;
      *)
        echo "[ ERROR ] Unknown Command"
        setEnd
        ;;
      esac
    done
  else
    sudo rm -rf app
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# App - PHP Framework - Symfony
# ----------------------------------------------------------------------------------------------------------------------

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
  # --------------------------------------------------------------------------------------------------------------------
  # Linux - Ubuntu Desktop
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/vm/ubuntu/etc/php/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/vm/ubuntu/etc/php/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/vm/ubuntu/etc/php/_install.sh" && exit
  fi

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Install the packages
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

    # >>>> PHP Extension
    local CURRENT_PHP_VERSION
    CURRENT_PHP_VERSION=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1-3)

    local PHP_EXT_REDIS
    PHP_EXT_REDIS=$(find /opt/homebrew/lib/php/pecl/ -name redis.so)
    if [ "${PHP_EXT_REDIS}" ]; then
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
      echo "Composer has been installed"
    else
      brew install composer
    fi

    # ------------------------------------------------------------------------------------------------------------------
    # Update the configuration
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # Check the status
    # ------------------------------------------------------------------------------------------------------------------

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Install the packages
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> PHP
    echo -n

    # ------------------------------------------------------------------------------------------------------------------
    # Update the configuration
    # ------------------------------------------------------------------------------------------------------------------

    # ------------------------------------------------------------------------------------------------------------------
    # Check the status
    # ------------------------------------------------------------------------------------------------------------------

  fi

  # --------------------------------------------------------------------------------------------------------------------
  # App - PHP Framework - Symfony
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Version                                                              https://symfony.com/doc/current/setup.html
  composer create-project symfony/skeleton:"${PHP_FRAMEWORK_VERSION}.*" app
  echo

  (
    cd app || return

    # >>>> Symfony Framework                                                  https://symfony.com/doc/current/setup.html
    composer require webapp
    echo

    # >>>> Symfony Bundles - Webpack                   https://symfony.com/doc/current/frontend/encore/installation.html
    composer require symfony/webpack-encore-bundle
    echo

    composer require symfony/stimulus-bundle
    echo
  )

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
  # --------------------------------------------------------------------------------------------------------------------
  # App - PHP Framework - Symfony
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Docker - Symfony Framework - recipes files
  if [ -f ${PROJECT_PATH}/app/docker-compose.yml ]; then
    echo ">>>> Symfony - deleted recipes files "
    find ${PROJECT_PATH}/app -name "docker-compose.yml" -exec rm -fv {} \;
    find ${PROJECT_PATH}/app -name "docker-compose.*.yml" -exec rm -fv {} \;
  else
    echo "There are not recipes files"
  fi
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
  echo
  echo "Please select a dev environment to deploy the new project using a shell script"
  echo
  echo " Prod Environment"
  echo
  echo "  1) AWS            : ./scripts/cloud/aws/deploy.sh"
  echo
  echo " Dev  Environment"
  echo
  echo "  2) Docker Desktop : ./scripts/docker/containers/deploy.sh"
  echo
  echo "  3) VM   - Ubuntu  : ./scripts/vm/ubuntu/deploy.sh"
  echo
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
#setDocker
#setVM

# ----------------------------------------------------------------------------------------------------------------------
# >>>> Tools
# ----------------------------------------------------------------------------------------------------------------------
#setGit
setIDE
#setWebBrowser

# >>>> End
setEnd