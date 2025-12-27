#!/bin/bash
# ======================================================================================================================
# Scripts - Base - App - Symfony Framework - Deployment - Other Things   https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> PHP - Symfony Command
    if [ -f bin/console ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # G) Other Things - Restarting your workers for Messenger: Sync & Queued Message Handling
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Deployment - G) Other Things - Restarting your workers for Messenger: Sync & Queued Message Handling"
      echo

      #symfony console messenger:setup-transports

      # >>>> Restarting your workers
      #if [ "${PLATFORM_TYPE}" == "Linux" ]; then
      #  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
      #    sudo supervisorctl restart messenger-consume:*
      #    echo
      #  fi
      #fi

    else
      echo "[ ERROR ] There is not a command : app/bin/console"
      setExit
    fi
  )
fi
