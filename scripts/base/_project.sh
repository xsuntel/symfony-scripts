#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Project
# ======================================================================================================================

# >>>> Git - Global - Config

echo ">>>> Git - Global"
echo

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  git config --global core.autocrlf input

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then

  git config --global core.autocrlf input

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then

  git config --global core.autocrlf true

else
  echo "Please check Operating System"
  setExit
fi

git config --global --list
echo

# ----------------------------------------------------------------------------------------------------------------------
# >>>> Git - Local - Config
# ----------------------------------------------------------------------------------------------------------------------

echo ">>>> Git - Local"
echo

local GIT_SAFE_DIRECTORY
GIT_SAFE_DIRECTORY=$(git config --local --list | grep -i "${PROJECT_PATH}")
if [ ! "${GIT_SAFE_DIRECTORY}" ]; then
  git config --local --add safe.directory "${PROJECT_PATH}"
fi

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  git config --local  core.autocrlf input

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then

  git config --locla  core.autocrlf input

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then

  git config --local  core.autocrlf true

else
  echo "Please check Operating System"
  setExit
fi

git config --local core.editor vi
git config --local color.ui true
git config --local diff.ui auto
git config --local format.pretty oneline
git config --local pull.rebase true
git config --local push.default simple

git config --local --list
echo

# ----------------------------------------------------------------------------------------------------------------------
# App
# ----------------------------------------------------------------------------------------------------------------------

if [ -d app ]; then
  (
    cd app || return

    # >>>> App - Symfony Command                                             https://symfony.com/doc/current/deployment.html
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

      # >>>> App - Symfony local server
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

# ----------------------------------------------------------------------------------------------------------------------
# Scripts
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Linux
if [ -f sudo ]; then
  rm -f sudo
fi

# >>>> MacOS


# >>>> Windows
find ./ -name ".DS_Store" -type f -exec rm -f {} \;
find ./ -name ".DS_Store" -type d -exec rm -rf {} \;

# >>>> Docker Desktop - a recipe file for Symfony
if [ -f ${PROJECT_PATH}/app/docker-compose.yml ]; then
  rm -f ${PROJECT_PATH}/app/docker-compose.*
fi

# >>>> Python - Virtual Environment
if [ -d .vendor ]; then
  rm -rf .vendor
fi

# >>>> Python - var/logs
if [ -d var ]; then
  rm -rf var
fi


# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Draw.io
find ./ -name "*.drawio.bkp" -type f -exec rm -f {} \;

# >>>> PhpStorm
if [ -f ~/java_error_in_phpstorm_.hprof ]; then
  rm -f ~/java_error_in_phpstorm_.hprof
  echo
fi
