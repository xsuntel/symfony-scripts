#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Local Web Server                         https://symfony.com/doc/current/setup/symfony_server.html
# ======================================================================================================================

echo ">>>> PHP - Symfony - Local Web Server"
echo

# ----------------------------------------------------------------------------------------------------------------------
# Local Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
if [ -f .symfony.local.yaml ]; then

  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

    # >>>> Platform
    if [ "${PLATFORM_TYPE}" != "Linux" ]; then

      # >>>> Platform : MacOS
      if [ "${PLATFORM_TYPE}" == "Darwin" ]; then
        local LOCAL_LISTEN_PORT
        LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".8020" | awk '{print $6}')
        if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
          symfony local:server:stop
          echo
        fi

      # >>>> Platform : Windows
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
    fi

    # >>>> Symfony CLI - Local Web Server
    symfony local:server:start --no-tls --no-workers --daemon
    echo

  fi

else
  echo "[ ERROR ] There is not a file : .symfony.local.yaml"
  settExit
fi
echo
