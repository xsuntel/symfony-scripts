#!/bin/bash
# ======================================================================================================================
# Tools - Git - Clear
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
  source ${PROJECT_PATH}/scripts/base/_abstract.sh
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# ----------------------------------------------------------------------------------------------------------------------
# System Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Environment"
  echo "---------------------------------------------------------------------------------------------------------------"
  PS3="Menu: "
  select num in "dev" "exit"; do
    case "$REPLY" in
    1)
      # >>>> Dev Environment
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

  # >>>> Project - Base - Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi

  # >>>> Delete a directory : ./app
  if [ "symfony" == "${PROJECT_NAME}" ] && [ -f ./tools/tutorial/create.sh ]; then
    if [ -d app ]; then
      rm -rf app
      mkdir -p app
      touch app/.gitkeep
    else
      mkdir -p app
      touch app/.gitkeep
    fi
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Symfony Framework
  if [ -d app ]; then
    (
      cd app || return

      # >>>> Symfony Command                                             https://symfony.com/doc/current/deployment.html
      if [ -f bin/console ]; then

        # --------------------------------------------------------------------------------------------------------------
        # Directories
        # --------------------------------------------------------------------------------------------------------------

        # >>>> Node
        if [ -d node_modules ]; then
          rm -rf node_modules
        fi

        # >>>> tests
        if [ -f tests/bootstrap.php ]; then
          rm -rf tests/*
        fi

        # >>>> var
        if [ -d var ]; then
          rm -rf var/*
        fi

        # >>>> vendor
        if [ -d vendor ]; then
          rm -rf vendor/*
        fi

        # --------------------------------------------------------------------------------------------------------------
        # files
        # --------------------------------------------------------------------------------------------------------------

        # >>>> .env.${ENVIRONMENT_NAME}
        if [ -f .env.${ENVIRONMENT_NAME} ]; then
          rm -f .env.${ENVIRONMENT_NAME}
        fi

        if [ -f .env.${ENVIRONMENT_NAME}.local ]; then
          rm -f .env.${ENVIRONMENT_NAME}.local
        fi

        # >>>> .env.test
        if [ -f .env.test ]; then
          rm -f .env.test
        fi

        # >>>> composer
        if [ -f composer.phar ]; then
          rm -f composer.phar
        fi

        if [ -f composer.lock ]; then
          rm -f composer.lock
        fi

        # >>>> package
        if [ -f package.json ]; then
          rm -f package.json
        fi

        if [ -f package-lock.json ]; then
          rm -f package-lock.json
        fi

        # >>>> phing-latest.phar
        if [ -f phing-latest.phar ]; then
          rm -f phing-latest.phar
        fi

        # >>>> php-cs-fixer
        if [ -f .php-cs-fixer.cache ]; then
          rm -f .php-cs-fixer.cache
        fi

        # >>>> phpunit
        if [ -f .phpunit.result.cache ]; then
          rm -f .phpunit.result.cache
        fi

        if [ -f phpunit.xml.dist ]; then
          rm -f phpunit.xml.dist
        fi

        # >>>> symfony local server
        if [ -f .symfony.local.yaml ]; then
          rm -f .symfony.local.yaml
        fi

      fi
    )
  else
    echo
    echo "[ ERROR ] There is not a folder : app"
    echo
  fi

  # >>>> php-cs-fixer
  if [ -f .php-cs-fixer.cache ]; then
    rm -f .php-cs-fixer.cache
  fi

  # >>>> phpunit
  if [ -f ./tests/.phpunit.result.cache ]; then
     rm -f ./tests/.phpunit.result.cache
  fi

  if [ -f .phpunit.result.cache ]; then
     rm -f .phpunit.result.cache
  fi

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
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - CDN"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Docker Desktop - a recipe file for Symfony
  if [ -f ${PROJECT_PATH}/app/docker-compose.yml ]; then
    echo ">>>> Docker - a recipe file for Symfony"
    rm -f ${PROJECT_PATH}/app/docker-compose.*
    echo
  fi

  # >>>> Docker Desktop - docker-compose files
  if [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.env ]; then
    rm -fv ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.env
  fi
  if [ -f ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.yml ]; then
    rm -fv ${PROJECT_PATH}/docker-compose.${ENVIRONMENT_NAME}.yml
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Git - Config - Global
  echo ">>>> Git - Config - Global"
  echo

  git config --global -l
  echo

  # >>>> Git - Config - Local
  echo ">>>> Git - Config - Local"
  echo

  git config --local -l
  echo

  # >>>> Git - Clear history
  echo ">>>> Git - Clear history"
  echo
  if [ -d .git ]; then
    rm -rf .git
    echo

    git init
    echo

    git add .
    echo

    git commit -m "${GIT_CONFIG_LOCAL_USER_NAME}"
    echo

    git remote add origin ${GIT_REMOTE_ORIGIN_URL}
    echo

    git push --mirror --force
    echo

    git status
  fi
  echo
}

# ======================================================================================================================
# START
# ======================================================================================================================

# >>>> Start
setStart

# ----------------------------------------------------------------------------------------------------------------------
# System Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment
setEnvironment

# >>>> Platform
setPlatform

# >>>> Project
setProject

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
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
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
