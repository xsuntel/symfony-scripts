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

          # >>>> Update a configuration
          cp -fv ../.symfony.local.yaml ./
          echo

          # >>>> Platform : MacOS
          if [ "${PLATFORM_TYPE}" == "Darwin" ]; then
            local LOCAL_LISTEN_PORT
            LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".8000" | awk '{print $6}')
            if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
              symfony server:stop
              echo
            fi
          # >>>> Platform : Windows
          elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
            local LOCAL_LISTEN_PORT
            LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep "8000" | awk '{print $6}')
            if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
              symfony server:stop
              echo
            fi
          else
            echo "Please check Operating System"
            setExit
          fi

          # >>>> Service
          symfony server:start
          echo
        fi

      else
        # >>>> Remove a configuration
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