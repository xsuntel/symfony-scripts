#!/bin/bash
# ======================================================================================================================
# Scripts - Project - Directories
# ======================================================================================================================

# >>>> Project
echo ">>>> Project - Git - Config - Local"
echo

# >>>> Git - Config - Local                                                                         https://git-scm.com/
git config --local user.name "${GIT_CONFIG_LOCAL_USER_NAME}"
git config --local user.email "${GIT_CONFIG_LOCAL_USER_EMAIL}"

git config --local init.defaultBranch main
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

# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> Create folders
    if [ ! -d migrations ]; then
      mkdir -p migrations
    fi

    # >>>> Remove .gitignore
    if [ -f ./src/Controller/.gitignore ]; then
      rm -f ./src/Controller/.gitignore
    fi

    if [ -f ./translations/.gitignore ]; then
      rm -f ./translations/.gitignore
    fi

    if [ -f ./.gitignore ]; then
      rm -f ./.gitignore
    fi

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
  setExit
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

# >>>> vendor
if [ -d vendor ]; then
  rm -rf vendor
fi

# >>>> var/logs
if [ -d var ]; then
  rm -rf var
fi