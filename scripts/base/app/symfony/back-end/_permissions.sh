#!/bin/bash
# ======================================================================================================================
# Scripts - Base - App - Symfony Framework - Deployment - Permissions    https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> PHP - Symfony Command
    if [ -f bin/console ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # D) Clear your Symfony Cache
      # ----------------------------------------------------------------------------------------------------------------
      echo ">>>> PHP - Symfony Framework - Deployment - Fixing File Permissions"
      echo
      # >>>> PHP - Symfony Framework - Setting up or Fixing File Permissions
      if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
        if [ "${PLATFORM_TYPE}" == "Linux" ]; then
          # ------------------------------------------------------------------------------------------------------------
          # Platform - Linux - Ubuntu
          # ------------------------------------------------------------------------------------------------------------
          HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"

          sudo usermod -a -G "${HTTPDUSER}" "$(whoami)"
          sudo chown "${HTTPDUSER}":"${HTTPDUSER}" -R ./*

          if [ -d var ]; then
            sudo setfacl -dR -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var
            sudo setfacl -R -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var

            sudo chmod 777 -R ./var
          fi
        elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
          # ------------------------------------------------------------------------------------------------------------
          # Platform - MacOS
          # ------------------------------------------------------------------------------------------------------------

          echo -n

        elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
          # ------------------------------------------------------------------------------------------------------------
          # Platform - Windows
          # ------------------------------------------------------------------------------------------------------------

          echo -n

        else
          echo "Please check Operating System"
          setExit
        fi
        echo
      fi

    else
      echo "[ ERROR ] There is not a command : app/bin/console"
      setExit
    fi
  )
fi
