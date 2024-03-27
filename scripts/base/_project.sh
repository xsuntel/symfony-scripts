#!/bin/bash
# ======================================================================================================================
# Scripts - Project - Directories
# ======================================================================================================================


# ----------------------------------------------------------------------------------------------------------------------
# Web Server
# ----------------------------------------------------------------------------------------------------------------------
# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> Remove cache files
    if [ -d var ]; then

      # >>>> Platform
      if [ "${PLATFORM_TYPE}" == "Linux" ]; then

        sudo rm -rf var/*
        mkdir -p var/cache
        mkdir -p var/log
        mkdir -p var/sessions
        mkdir -p var/translations
        sudo chmod 777 var

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
  )
else
  echo
  echo "[ ERROR ] There is not a folder : app"
  echo
fi

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Node
if [ -d node_modules ]; then
  rm -rf node_modules
fi

# >>>> composer.lock
if [ -f composer.lock ]; then
  rm -f composer.lock
fi

# >>>> symfony.lock
if [ -f symfony.lock ]; then
  rm -f symfony.lock
fi

# >>>> phpunit
if [ -f .phpunit.result.cache ]; then
  rm -f .phpunit.result.cache
fi

# >>>> php-cs-fixer
if [ -f .php-cs-fixer.cache ]; then
  rm -f .php-cs-fixer.cache
fi

# >>>> composer.phar
if [ -f composer.phar ]; then
  rm -f composer.phar
fi

# >>>> phing-latest.phar
if [ -f phing-latest.phar ]; then
  rm -f phing-latest.phar
fi

# >>>> Tests
if [ -d tests ]; then
  rm -rf tests
fi
if [ -d test ]; then
  rm -rf test
fi

# >>>> Logs
if [ -d var ]; then
  rm -rf var
fi

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Docker Desktop - a recipe file for Symfony
if [ -f ${PROJECT_PATH}/app/docker-compose.yml ]; then
  rm -f ${PROJECT_PATH}/app/docker-compose.*
  echo
fi

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Python - Virtual Environment
if [ -d vendor ]; then
  rm -rf vendor
fi
if [ -d .vendor ]; then
  rm -rf .vendor
fi

# >>>> Files
find ./ -name ".DS_Store" -type f -exec rm -f {} \;
find ./ -name ".DS_Store" -type d -exec rm -rf {} \;

if [ -f sudo ]; then
  rm -f sudo
fi