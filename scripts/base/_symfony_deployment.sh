#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Deployment                                         https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> Deployment
if [ -d app ]; then
  (
    cd app || return

    # >>>> Symfony Framework
    if [ -f bin/console ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # Common Deployment Tasks - A) Check Requirements
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Common Deployment Tasks - A) Check Requirements"
      echo
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 composer require symfony/requirements-checker
        echo
      else
        echo "Dev Environment"
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Common Deployment Tasks - B) Configure your Environment Variables
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Common Deployment Tasks - B) Configure your Environment Variables"
      echo
      # >>>> Symfony - .env files
      if [ -f .env ]; then
        find ./ -name ".env.*" -exec rm -fv {} \;

        if [ -f ../.env.${ENVIRONMENT_NAME} ]; then
          cp -fv ../.env.${ENVIRONMENT_NAME} ./.env.${ENVIRONMENT_NAME}
        fi
        if [ -f ../.env.${ENVIRONMENT_NAME}.local ]; then
          cp -fv ../.env.${ENVIRONMENT_NAME}.local ./.env.${ENVIRONMENT_NAME}.local
        fi
      else
        echo "There is not a env file (.env)"
        setExit
      fi
      echo

      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 composer dump-env ${ENVIRONMENT_NAME}
        echo
      fi

      # ----------------------------------------------------------------------------------------------------------------
      # Common Deployment Tasks - C) Install/Update your Vendors
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Common Deployment Tasks - C) Install/Update your Vendors"
      echo
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 composer install --no-dev --optimize-autoloader
      else
        APP_ENV=dev  APP_DEBUG=1 composer install --ignore-platform-req=ext-redis
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Common Deployment Tasks - D) Clear your Symfony Cache
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Common Deployment Tasks - D) Clear your Symfony Cache"
      echo
      # >>>> Remove cache files
      if [ -d var ]; then
        if [ -d var/cache ]; then
          # >>>> Platform
          if [ "${PLATFORM_TYPE}" == "Linux" ]; then
            sudo rm -rf var/cache/*
          else
            rm -rf var/cache/*
          fi
        fi
      fi

      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 php bin/console cache:clear --env=prod --no-warmup --no-optional-warmers
      else
        APP_ENV=dev  APP_DEBUG=1 php bin/console cache:clear --env=dev
      fi

      # ----------------------------------------------------------------------------------------------------------------
      # Common Deployment Tasks - E) Other Things
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Common Deployment Tasks - E) Other Things"
      echo
      # >>>> Remove installed recipe files

      # >>>> Running any database migrations

      # >>>> Add/edit CRON jobs

      # >>>> Restarting your workers

      # >>>> Compile your assets if you're using the AssetMapper component

      # ----------------------------------------------------------------------------------------------------------------
      # >>>> TailwindBundle                                https://symfony.com/bundles/TailwindBundle/current/index.html
      # ----------------------------------------------------------------------------------------------------------------
      #if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
      #  php bin/console tailwind:build --minify
      #  php bin/console asset-map:compile
      #elif [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      #  php bin/console tailwind:build -v
      #  php bin/console asset-map:compile
      #else
      #  echo "Please check your environment"
      #fi

      # >>>> Pushing assets to a CDN

    else
      echo "[ ERROR ] There is not a command : app/bin/console"
      exit
    fi

    # >>>> Symfony Framework - Setting up or Fixing File Permissions
    if [ "${PLATFORM_TYPE}" == "Linux" ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Linux                                                https://symfony.com/doc/current/setup/file_permissions.html
      # ----------------------------------------------------------------------------------------------------------------

      HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"

      sudo setfacl -dR -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var
      sudo setfacl -R -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var

    fi

  )
else
  echo "[ ERROR ] There is not a folder : app"
  exit
fi
