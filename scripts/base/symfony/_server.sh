#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Symfony - Local Web Server                  https://symfony.com/doc/current/setup/symfony_server.html
# ======================================================================================================================

# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> Symfony Framework
    if [ -f bin/console ]; then

      # >>>> Environment
      if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

        # >>>> Platform
        echo ">>>> PHP - Symfony - Local Web Server"
        echo

        # ------------------------------------------------------------------------------------------------------------
        # Platform - Linux
        # ------------------------------------------------------------------------------------------------------------
        if [ "${PLATFORM_TYPE}" == "Linux" ]; then
          local LOCAL_LISTEN_PORT
          LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".8080" | awk '{print $6}')
          if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
            symfony local:server:stop
            echo
          fi

          # >>>> Symfony - Local Web Server - Enabling TLS
          if [ ! -f ~/.symfony5/certs/default.p12 ]; then
            symfony server:ca:install
          fi

        # ------------------------------------------------------------------------------------------------------------
        # Platform - MacOS
        # ------------------------------------------------------------------------------------------------------------
        elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
          local LOCAL_LISTEN_PORT
          LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".8080" | awk '{print $6}')
          if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
            symfony local:server:stop
            echo
          fi

          # >>>> Symfony - Local Web Server - Enabling TLS
          symfony server:ca:install

        # ------------------------------------------------------------------------------------------------------------
        # Platform - Windows
        # ------------------------------------------------------------------------------------------------------------
        elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
          local LOCAL_LISTEN_PORT
          LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep "8080" | awk '{print $6}')
          if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
            symfony local:server:stop
            echo
          fi

          # >>>> Symfony - Local Web Server - Enabling TLS
          symfony server:ca:install

        else
          echo "Please check Operating System"
          setExit
        fi

        # >>>> Symfony - Local Web Server
        if [ -f ${PROJECT_PATH}/tools/.symfony.local.yaml ]; then
          cp -fv ${PROJECT_PATH}/tools/.symfony.local.yaml ${PROJECT_PATH}/app/.symfony.local.yaml
          echo
        fi

        if [ -f ${PROJECT_PATH}/app/.symfony.local.yaml ]; then
          symfony server:ls
          echo

          symfony local:server:start
          echo

          symfony server:status

        else
          echo "[ ERROR ] There is not a file : .symfony.local.yaml"
          settExit
        fi

      else

        if [ -f ${PROJECT_PATH}/app/.symfony.local.yaml ]; then
          rm -f ${PROJECT_PATH}/app/.symfony.local.yaml
        fi

      fi
      echo

    else
      echo "[ ERROR ] There is not a command : app/bin/console"
      setExit
    fi
  )
fi
echo



