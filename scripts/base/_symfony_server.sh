#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Symfony - Local Web Server                  https://symfony.com/doc/current/setup/symfony_server.html
# ======================================================================================================================

# >>>> Environment
if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" != "Linux" ]; then

    echo ">>>> PHP - Symfony - Local Web Server"
    echo

    # >>>> App
    if [ -f .symfony.local.yaml ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Platform - MacOS
      # ----------------------------------------------------------------------------------------------------------------
      if [ "${PLATFORM_TYPE}" == "Darwin" ]; then
        local LOCAL_LISTEN_PORT
        LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".8020" | awk '{print $6}')
        if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
          symfony local:server:stop
          echo
        fi

      # ----------------------------------------------------------------------------------------------------------------
      # Platform - Windows
      # ----------------------------------------------------------------------------------------------------------------
      elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
        local LOCAL_LISTEN_PORT
        LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep "8020" | awk '{print $6}')
        if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
          symfony local:server:stop
          echo
        fi

      else
        echo "Please check Operating System"
        setExit
      fi

      # >>>> Symfony CLI - Local Web Server
      symfony local:server:start --no-tls --no-workers --daemon
      echo

    else
      echo "[ ERROR ] There is not a file : .symfony.local.yaml"
      settExit
    fi
  fi
fi
echo
