#!/bin/bash
# ======================================================================================================================
# Scripts - Project - Directories
# ======================================================================================================================

echo ">>>> Project - Git - Config - Local"
echo

# >>>> Git - Config - Local                                                                         https://git-scm.com/
git config --local user.name "${GIT_CONFIG_LOCAL_USER_NAME}"
git config --local user.email "${GIT_CONFIG_LOCAL_USER_EMAIL}"

git config --local init.defaultBranch master
git config --local core.editor vi
git config --local core.autocrlf false
git config --local color.ui true
git config --local diff.ui auto
git config --local format.pretty oneline
git config --local push.default simple

git config --local credential.helper store

local GIT_SAFE_DIRECTORY
GIT_SAFE_DIRECTORY=$(git config --local --list | grep -i "${PROJECT_PATH}")
if [ ! "${GIT_SAFE_DIRECTORY}" ]; then
  git config --local --add safe.directory "${PROJECT_PATH}"
fi

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

echo ">>>> Project - App"
echo

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

# >>>> Python - Virtual Environment
if [ -d .vendor ]; then
  rm -rf .vendor
fi

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Docker Desktop - a recipe file for Symfony
if [ -f ${PROJECT_PATH}/app/docker-compose.yml ]; then
  rm -f ${PROJECT_PATH}/app/docker-compose.*
fi

# ----------------------------------------------------------------------------------------------------------------------
# Instance
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

# >>>> phpunit
if [ -f .phpunit.result.cache ]; then
  rm -f .phpunit.result.cache
fi

# >>>> php-cs-fixer
if [ -f .php-cs-fixer.cache ]; then
  rm -f .php-cs-fixer.cache
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

# >>>> Vendor
if [ -d vendor ]; then
  rm -rf vendor
fi

# >>>> Logs
if [ -d var ]; then
  rm -rf var
fi