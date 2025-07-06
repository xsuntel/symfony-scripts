#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Project
# ======================================================================================================================

# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> Symfony Command                                             https://symfony.com/doc/current/deployment.html
    if [ -f bin/console ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # Directories
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> assets
      if [ -f assets/controllers/hello_controller.js ]; then
        rm -f assets/controllers/hello_controller.js
        echo
      fi

      # >>>> migrations
      if [ ! -d migrations ]; then
        mkdir -p migrations
      fi

      # >>>> node_modules
      if [ -d node_modules ]; then
        rm -rf node_modules
      fi

      # >>>> src
      if [ -f ./src/Controller/.gitignore ]; then
        rm -f ./src/Controller/.gitignore
      fi

      # >>>> templates
      if [ -f templates/base.html.twig ]; then
        rm -f templates/base.html.twig
        echo
      fi

      # >>>> translations
      if [ -f ./translations/.gitignore ]; then
        rm -f ./translations/.gitignore
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

      # >>>> vendor
      if [ -d vendor ]; then
        rm -rf vendor/*
      fi

      # ----------------------------------------------------------------------------------------------------------------
      # Files
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> .gitignore
      if [ -f ./.gitignore ]; then
        rm -f ./.gitignore
      fi

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

      # >>>> symfony local server
      if [ -f .symfony.local.yaml ]; then
        rm -f .symfony.local.yaml
      fi

      # >>>> Remove related performance files
      if [ -f ./[0-9].meta.json ]; then
        rm -f ./[0-9]
        rm -f ./[0-9].meta
        rm -f ./[0-9].meta.json
      fi

    fi
  )
else
  echo
  echo "[ ERROR ] There is not a folder : app"
  echo
  setExit
fi

# ----------------------------------------------------------------------------------------------------------------------
# CDN - Content Delivery Networks
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Python - Virtual Environment
if [ -d .vendor ]; then
  rm -rf .vendor
fi

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Docker Desktop - a recipe file for Symfony
if [ -f ${PROJECT_PATH}/app/docker-compose.yml ]; then
  rm -f ${PROJECT_PATH}/app/docker-compose.*
fi

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Extra Files
find ./ -name ".DS_Store" -type f -exec rm -f {} \;
find ./ -name ".DS_Store" -type d -exec rm -rf {} \;

if [ -f sudo ]; then
  rm -f sudo
fi

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Draw.io
find ./ -name "*.drawio.bkp" -type f -exec rm -f {} \;

# >>>> PhpStorm
if [ -f ~/java_error_in_phpstorm_.hprof ]; then
  rm -fv ~/java_error_in_phpstorm_.hprof
  echo
fi

# ----------------------------------------------------------------------------------------------------------------------
# Tutorial
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Node
if [ -d node_modules ]; then
  rm -rf node_modules
fi

# >>>> composer
if [ -f composer.phar ]; then
  rm -f composer.phar
fi

if [ -f composer.json ]; then
  rm -f composer.json
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

# >>>> webpack-encore
if [ -f npm-debug.log ]; then
  rm -f npm-debug.log
fi

if [ -f yarn-error.log ]; then
  rm -f yarn-error.log
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
if [ -f ./tests/.phpunit.result.cache ]; then
  rm -f ./tests/.phpunit.result.cache
fi

if [ -f .phpunit.result.cache ]; then
  rm -f .phpunit.result.cache
fi

# >>>> vendor
if [ -d vendor ]; then
  rm -rf vendor
fi

# >>>> var/logs
if [ -d var ]; then
  rm -rf var
fi