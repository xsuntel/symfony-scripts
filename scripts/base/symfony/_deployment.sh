#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Symfony - Deployment                                  https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then

    # >>>> Project - Git
    if [ -d .git ]; then
      echo ">>>> Git - Update this project"

      DEFAULT_BRANCH=$(git config --get init.defaultBranch)

      git config pull.rebase true

      git reset --hard

      git pull origin "${DEFAULT_BRANCH}" -f
      echo

    else
      echo "There is not .git file"
    fi
    echo

  fi

fi

# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> Symfony Framework
    if [ -f bin/console ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # A) Check Requirements
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - A) Check Requirements"
      echo
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        symfony check:requirements
      else
        echo "Dev Environment"
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # B) Configure your Environment Variables
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - B) Configure your Environment Variables"
      echo
      # >>>> Symfony - .env files
      if [ -f .env ]; then
        rm -f .env.*
        if [ -f ../.env.${ENVIRONMENT_NAME} ]; then
          cp -fv ../.env.${ENVIRONMENT_NAME} ./.env.${ENVIRONMENT_NAME}
        fi

        # >>>> Dev Environment - Local
        if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
          if [ -f ../.env.${ENVIRONMENT_NAME}.local ]; then
            cp -fv ../.env.${ENVIRONMENT_NAME}.local ./.env.${ENVIRONMENT_NAME}.local
          fi
        fi
      else
        echo "There is not a env file (.env)"
        setExit
      fi

      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        # >>>> Deployment
        APP_ENV=prod APP_DEBUG=0 composer dump-env ${ENVIRONMENT_NAME}
        echo
        # >>>> Performance - Optimize Composer Autoloader               https://symfony.com/doc/current/performance.html
        APP_ENV=prod APP_DEBUG=0 composer dump-autoload --no-dev --classmap-authoritative
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # C) Install/Update your Vendors
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - C) Install/Update your Vendors"
      echo
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        APP_ENV=prod APP_DEBUG=0 composer install --no-dev --optimize-autoloader
      else
        APP_ENV=dev  APP_DEBUG=1 composer install --ignore-platform-req=ext-redis
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # D) Clear your Symfony Cache
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - D) Clear your Symfony Cache"
      echo
      # >>>> Symfony Framework - Remove cache files
      if [ -d var/cache ]; then
        # >>>> Platform
        if [ "${PLATFORM_TYPE}" == "Linux" ]; then
          if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
            sudo rm -rf var/cache/*
          fi
          rm -rf var/cache/*
        else
          rm -rf var/cache/*
        fi
      fi

      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        # >>>> Symfony Framework - Clear cache
        APP_ENV=prod APP_DEBUG=0 php bin/console cache:clear --env=prod --no-warmup --no-optional-warmers

        # >>>> Symfony Framework - Setting up or Fixing File Permissions
        if [ "${PLATFORM_TYPE}" == "Linux" ]; then
          # ----------------------------------------------------------------------------------------------------------------
          # Platform - Linux - Ubuntu
          # ----------------------------------------------------------------------------------------------------------------
          HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"

          sudo usermod -a -G "${HTTPDUSER}" "$(whoami)"
          sudo chown "${HTTPDUSER}":"${HTTPDUSER}" -R ./*

          if [ -d var ]; then
            sudo setfacl -dR -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var
            sudo setfacl -R -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var

            sudo chmod 777 -R ./var
          fi
        fi
        echo
      else
        # >>>> Symfony Framework - Clear cache
        APP_ENV=dev  APP_DEBUG=1 php bin/console cache:clear --env=dev

        # >>>> Symfony Framework - Setting up or Fixing File Permissions
        if [ "${PLATFORM_TYPE}" == "Linux" ]; then
          # ----------------------------------------------------------------------------------------------------------------
          # Platform - Linux - Ubuntu
          # ----------------------------------------------------------------------------------------------------------------
          chown -R "${LOGNAME}":"${LOGNAME}" -R ./*

          if [ -d var ]; then
            chmod 777 -R ./var
          fi
        fi
        echo
      fi

      # ----------------------------------------------------------------------------------------------------------------
      # E) Other Things - Running any database migrations
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - E) Other Things - Running any database migrations"
      echo

      # >>>> Running any database migrations

      # ----------------------------------------------------------------------------------------------------------------
      # F) Other Things - Add/edit CRON jobs
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - F) Other Things - Add/edit CRON jobs"
      echo

      # >>>> Add/edit CRON jobs

      # ----------------------------------------------------------------------------------------------------------------
      # G) Other Things - Restarting your workers for Messenger: Sync & Queued Message Handling
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - G) Other Things - Restarting your workers for Messenger: Sync & Queued Message Handling"
      echo

      # >>>> Restarting your workers
      #if [ "${PLATFORM_TYPE}" == "Linux" ]; then
      #  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
      #    sudo supervisorctl restart messenger-consume:*
      #    echo
      #  fi
      #fi

      # ----------------------------------------------------------------------------------------------------------------
      # H) Other Things - Webpack Encore or AssetMapper
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - H) Other Things - Webpack Encore or AssetMapper"
      echo

      # >>>> Compile your assets if you're using the AssetMapper component

      # >>>> TailwindBundle                                https://symfony.com/bundles/TailwindBundle/current/index.html
      #if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
      #  echo '----> Building'
      #  echo
      #  php bin/console tailwind:build --minify
      #  echo

      #else
      #  echo '----> Building'
      #  echo

      #  echo
      #  php bin/console tailwind:build -v
      #  echo

      #  npx -y update-browserslist-db@latest
      #  echo

      #fi
      #  echo '----> Compiling'
      #  echo

      #  php bin/console asset-map:compile
      #  echo

      # ----------------------------------------------------------------------------------------------------------------
      # I) Other Things - Content Delivery Network
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony - Deployment - I) Other Things - Content Delivery Network"
      echo

      # >>>> Pushing assets to a CDN

    else
      echo "[ ERROR ] There is not a command : app/bin/console"
      setExit
    fi
  )
fi
