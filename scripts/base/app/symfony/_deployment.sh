#!/bin/bash
# ======================================================================================================================
# Scripts - Base - App - Symfony Framework - Deployment                  https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> App
if [ -d app ]; then
  (
    cd app || return
    # >>>> PHP - Symfony Command
    if [ -f bin/console ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # A) Check Requirements
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Deployment - A) Check Requirements"
      echo
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 composer require symfony/requirements-checker
      else
        echo "Dev Environment"
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # B) Configure your Environment Variables
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Deployment - B) Configure your Environment Variables"
      echo
      # >>>> PHP - Symfony Framework - .env files
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        if [ -f ../.env.prod ]; then
          cp -fv ../.env.prod ./.env.prod
        fi
        if [ -f ../.env.prod.local ]; then
          cp -fv ../.env.prod.local ./.env.prod.local
        fi
        rm -f .env.dev
        rm -f .env.dev.local
        rm -f .env.test
        rm -f .env.test.local

      elif [ "${ENVIRONMENT_NAME}" == "dev" ]; then
        if [ -f ../.env.dev ]; then
          cp -fv ../.env.dev ./.env.dev
        fi
        if [ -f ../.env.dev.local ]; then
          cp -fv ../.env.dev.local ./.env.dev.local
        fi
        rm -f .env.prod
        rm -f .env.prod.local

      else
        rm -f .env.*
        rm -f .env.*.local
      fi

      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        # >>>> Deployment
        APP_ENV=prod APP_DEBUG=0 composer dump-env prod
        echo
        # >>>> Performance - Optimize Composer Autoloader               https://symfony.com/doc/current/performance.html
        APP_ENV=prod APP_DEBUG=0 composer dump-autoload --no-dev --classmap-authoritative
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # C) Install/Update your Vendors
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Deployment - C) Install/Update your Vendors"
      echo
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 composer install --no-dev --optimize-autoloader
      else
        APP_ENV=dev  APP_DEBUG=1 composer install --ignore-platform-req=ext-redis --ignore-platform-req=ext-amqp --ignore-platform-req=ext-pdo_pgsql
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # D) Clear your Symfony Cache
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Deployment - D) Clear your Symfony Cache"
      echo
      # >>>> PHP - Symfony Framework - Remove cache files
      if [ -d var/cache ]; then
        if [ "${PLATFORM_TYPE}" == "Linux" ]; then
          if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
            if [ -d var/cache/prod ]; then
              sudo rm -rf var/cache/prod/*
            fi

            if [ -d var/cache/dev ]; then
              sudo rm -rf var/cache/dev/*
            fi
          else
            if [ -d var/cache/prod ]; then
              rm -rf var/cache/prod/*
            fi

            if [ -d var/cache/dev ]; then
              rm -rf var/cache/dev/*
            fi
          fi
        else
          if [ -d var/cache/prod ]; then
            rm -rf var/cache/prod/*
          fi

          if [ -d var/cache/dev ]; then
            rm -rf var/cache/dev/*
          fi
        fi
      else
        mkdir -p var/cache
      fi

      # >>>> PHP - Symfony Framework - Clear cache
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 php bin/console cache:clear --env=prod --no-warmup --no-optional-warmers
        echo
      else
        APP_ENV=dev  APP_DEBUG=1 php bin/console cache:clear --env=dev
        if [ "${PLATFORM_TYPE}" == "Linux" ]; then
          chown -R "${LOGNAME}:${LOGNAME}" -R ./*
          if [ -d var ]; then
            chmod 775 -R ./var
          fi
        fi
        echo
      fi

      # >>>> PHP - Symfony Framework - Remove log files
      if [ -d var/log ]; then
        if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
          # >>>> var/log/prod.log
          if [ -f var/log/prod.log ]; then
            cat /dev/null > var/log/prod.log
          else
            touch var/log/prod.log
          fi
        else
          # >>>> var/log/dev.log
          if [ -f var/log/dev.log ]; then
            cat /dev/null > var/log/dev.log
            rm -f var/log/dev-*.log
          else
            touch var/log/dev.log
          fi

          if [ -f var/log/xdebug.log ]; then
            cat /dev/null > var/log/xdebug.log
          fi
        fi
      else
        mkdir -p var/log
      fi

    else
      echo "[ ERROR ] There is not a command : app/bin/console"
      setExit
    fi
  )
fi
