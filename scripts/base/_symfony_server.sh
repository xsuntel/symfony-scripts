#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Local Web Server                         https://symfony.com/doc/current/setup/symfony_server.html
# ======================================================================================================================

echo ">>>> PHP - Symfony - Local Web Server"
echo

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

        # >>>> Platform
        if [ "${PLATFORM_TYPE}" != "Linux" ]; then

          # >>>> configuration
          if [ -f .symfony.local.yaml ]; then
            rm -f .symfony.local.yaml
          fi
          cp -f ../.symfony.local.yaml ./

          # >>>> Service
          local LOCAL_WEB_PORT
          LOCAL_WEB_PORT=$(netstat -napotl | grep -i LISTEN | grep -v tcp6 | grep "0.0.0.0:8000" | awk '{print $6}')
          if [ "${LOCAL_WEB_PORT}" == "LISTEN" ]; then
            symfony server:stop
            echo

            symfony server:start
            echo
          fi
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