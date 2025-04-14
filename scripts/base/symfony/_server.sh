#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Symfony - Local Web Server                  https://symfony.com/doc/current/setup/symfony_server.html
# ======================================================================================================================

# >>>> Environment
if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

  # >>>> Platform
  echo ">>>> PHP - Symfony - Local Web Server"
  echo

  if [ -f .symfony.local.yaml ]; then
    # ----------------------------------------------------------------------------------------------------------------
    # Platform - Linux
    # ----------------------------------------------------------------------------------------------------------------
    if [ "${PLATFORM_TYPE}" == "Linux" ]; then
      local LOCAL_LISTEN_PORT
      LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".8000" | awk '{print $6}')
      if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
        symfony local:server:stop
        echo
      fi
      # >>>> Symfony - Local Web Server - Enabling TLS
      symfony server:ca:install

    # ----------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ----------------------------------------------------------------------------------------------------------------
    elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
      local LOCAL_LISTEN_PORT
      LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep ".8000" | awk '{print $6}')
      if [ "${LOCAL_LISTEN_PORT}" == "LISTEN" ]; then
        symfony local:server:stop
        echo
      fi
      # >>>> Symfony - Local Web Server - Enabling TLS
      symfony server:ca:install

    # ----------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ----------------------------------------------------------------------------------------------------------------
    elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
      local LOCAL_LISTEN_PORT
      LOCAL_LISTEN_PORT=$(netstat -an | grep -i LISTEN | grep -v tcp6 | grep "8000" | awk '{print $6}')
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
    symfony local:server:start
    #symfony local:server:start --no-tls --no-workers --daemon

    symfony server:ls
    echo

  else
    echo "[ ERROR ] There is not a file : .symfony.local.yaml"
    settExit
  fi
fi
echo
