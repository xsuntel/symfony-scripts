#!/bin/bash
# ======================================================================================================================
# Scripts - App - PHP Framework - Symfony - Deployment
# ======================================================================================================================
# >>>> Deployment                                                        https://symfony.com/doc/current/deployment.html
if [ -d app ]; then
  (
    cd app || return

    # >>>> Symfony Framework
    if [ -f bin/console ]; then

      # A) Check Requirements
      echo ">>>> A) Check Requirements"
      echo
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 composer require symfony/requirements-checker
        echo
      else
        echo "Dev Environment"
      fi
      echo

      # B) Configure your Environment Variables
      echo ">>>> B) Configure your Environment Variables"
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
      fi
      echo

      # C) Install/Update your Vendors
      echo ">>>> C) Install/Update your Vendors"
      echo

      # D) Clear your Symfony Cache
      echo ">>>> D) Clear your Symfony Cache"
      echo
      if [ -d var/cache ]; then
        sudo rm -rf var/cache/*
      fi
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 php bin/console cache:clear --env=prod --no-warmup --no-optional-warmers
      else
        APP_ENV=dev  APP_DEBUG=1 php bin/console cache:clear --env=dev
      fi

      # E) Other Things
      echo ">>>> E) Other Things"
      echo
      # >>>> Remove installed recipe files
      if [ -f assets/controllers/hello_controller.js ]; then
        rm -f assets/controllers/hello_controller.js
      fi
      if [ -f templates/base.html.twig ]; then
        rm -f templates/base.html.twig
      fi

      # >>>> Running any database migrations

      # >>>> Add/edit CRON jobs

      # >>>> Restarting your workers

      # >>>> Compile your assets if you're using the AssetMapper component
      if [ -f ../tutorial/assets/bootstrap.js ]; then
        cp -frv ../tutorial/assets/bootstrap.js ./assets/
        echo
      fi

      # >>>> TailwindBundle                                https://symfony.com/bundles/TailwindBundle/current/index.html
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        php bin/console tailwind:build --minify
        php bin/console asset-map:compile
      else
        php bin/console tailwind:build
        php bin/console config:dump symfonycasts_tailwind
        php bin/console importmap:audit
        php bin/console debug:asset-map
        php bin/console asset-map:compile
      fi
      echo

      # >>>> Pushing assets to a CDN

    else
      echo "[ ERROR ] There is not a command : app/bin/console"
      setExit
    fi
  )
else
  echo "[ ERROR ] There is not a folder : app"
  setExit
fi
