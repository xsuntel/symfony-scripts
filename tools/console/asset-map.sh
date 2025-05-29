#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Console Commands - Asset
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
cd "${PROJECT_PATH}" || exit

echo "---------------------------------------------------------------------------------------------------------------"
echo "[ Symfony ] Console Commands - Asset"
echo "---------------------------------------------------------------------------------------------------------------"
echo

  # >>>> Symfony Framework
  if [ -d app ]; then
    (
      cd app || return

      # >>>> Symfony Command                                             https://symfony.com/doc/current/deployment.html
      if [ -f bin/console ]; then

        # >>>> Select one of some environments
        PS3="Menu: "
        select num in "debug" "audit" "outdated" "update" "exit"; do
          case "$REPLY" in
          1)
            CONSOLE_COMMANDS="debug"
            break
            ;;
          2)
            CONSOLE_COMMANDS="audit"
            break
            ;;
          3)
            CONSOLE_COMMANDS="outdated"
            break
            ;;
          4)
            CONSOLE_COMMANDS="update"
            break
            ;;
          5)
            echo "exit()"
            exit
            ;;
          *)
            echo "[ ERROR ] Unknown Command"
            exit
            ;;
          esac
        done
        echo

        # --------------------------------------------------------------------------------------------------------------
        # 1) asset-map
        # --------------------------------------------------------------------------------------------------------------
        if [ "${CONSOLE_COMMANDS}" == "debug" ]; then
          echo ">>>> asset-map"
          symfony console debug:asset-map

        # --------------------------------------------------------------------------------------------------------------
        # 2) dotenv
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "audit" ]; then
          echo ">>>> importmap:audit"
          symfony console importmap:audit

        # --------------------------------------------------------------------------------------------------------------
        # 3) dotenv
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "outdated" ]; then
          echo ">>>> importmap:updated"
          symfony console importmap:outdated

        # --------------------------------------------------------------------------------------------------------------
        # 4) dotenv
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "update" ]; then
          echo ">>>> importmap:update"
          symfony console importmap:update

        fi
        echo

      else
        echo "[ ERROR ] There is not a command : app/bin/console"
        exit
      fi
    )
  else
    echo "[ ERROR ] There is not a folder : app"
    setExit
  fi
  echo
