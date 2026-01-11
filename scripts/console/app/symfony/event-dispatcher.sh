#!/bin/bash
# ======================================================================================================================
# Scripts - Console - App - Symfony - Console Commands - Event Dispatcher
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")")
cd "${PROJECT_PATH}" || exit

echo "---------------------------------------------------------------------------------------------------------------"
echo "[ Symfony ] Console Commands - Event Dispatcher"
echo "---------------------------------------------------------------------------------------------------------------"
echo

  # >>>> Directory
  if [ -d app ]; then
    (
      cd app || return

      # >>>> PHP - Symfony Command                                        https://symfony.com/doc/current/deployment.html
      if [ -f bin/console ]; then

        # >>>> Select one of some environments
        PS3="Menu: "
        select num in "debug" "kernel" "security" "exit"; do
          case "$REPLY" in
          1)
            CONSOLE_COMMANDS="debug"
            break
            ;;
          2)
            CONSOLE_COMMANDS="kernel"
            break
            ;;
          3)
            CONSOLE_COMMANDS="security"
            break
            ;;
          4)
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
        # 1) debug
        # --------------------------------------------------------------------------------------------------------------
        if [ "${CONSOLE_COMMANDS}" == "debug" ]; then
          echo ">>>> debug"
          symfony console debug:event-dispatcher

        # --------------------------------------------------------------------------------------------------------------
        # 2) kernel
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "kernel" ]; then
          echo ">>>> debug:event-dispatcher"
          symfony console debug:event-dispatcher kernel.exception

        # --------------------------------------------------------------------------------------------------------------
        # 3) security
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "security" ]; then
          echo ">>>> debug:event-dispatcher"
          symfony console debug:event-dispatcher Security

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
