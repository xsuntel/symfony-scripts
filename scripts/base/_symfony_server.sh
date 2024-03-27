#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Local Web Server                         https://symfony.com/doc/current/setup/symfony_server.html
# ======================================================================================================================


# ----------------------------------------------------------------------------------------------------------------------
# Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> Symfony Framework
    if [ -f bin/console ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # A) Local Web Server
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Environment
      if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
        echo ">>>> PHP - Symfony - Local Web Server"
        echo

        # >>>> Platform
        if [ "${PLATFORM_TYPE}" != "Linux" ]; then

          # >>>> configuration
          if [ -f .symfony.local.yaml ]; then
            rm -f .symfony.local.yaml
            cp -f ../.symfony.local.yaml ./
          else
            cp -f ../.symfony.local.yaml ./
          fi

          # >>>> Service
          local LOCAL_WEB_PORT
          LOCAL_WEB_PORT=$(netstat -anv | grep "*.8080" | awk '{print $6}')
          if [ "${LOCAL_WEB_PORT}" == "LISTEN" ]; then
            symfony server:stop
            echo
          fi

            symfony server:start
            echo

        fi

      else
        # >>>> configuration
        if [ -f .symfony.local.yaml ]; then
          rm -f .symfony.local.yaml
        fi
      fi
    fi
  )
else
  echo "[ ERROR ] There is not a folder : app"
  exit
fi