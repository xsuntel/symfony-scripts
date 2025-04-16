#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Console Commands - Messenger
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
cd "${PROJECT_PATH}" || exit

echo "---------------------------------------------------------------------------------------------------------------"
echo "[ Symfony ] Console Commands - Messenger"
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
        select num in "debug" "consume" "stats" "failed" "remove" "setup" "stop" ; do
          case "$REPLY" in
          1)
            CONSOLE_COMMANDS="debug"
            break
            ;;
          2)
            CONSOLE_COMMANDS="consume"
            break
            ;;
          3)
            CONSOLE_COMMANDS="stats"
            break
            ;;
          4)
            CONSOLE_COMMANDS="failed"
            break
            ;;
          5)
            CONSOLE_COMMANDS="remove"
            break
            ;;
          6)
            CONSOLE_COMMANDS="setup"
            break
            ;;
          7)
            CONSOLE_COMMANDS="stop"
            break
            ;;
          8)
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
          php bin/console debug:messenger

        # --------------------------------------------------------------------------------------------------------------
        # 2) consume
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "consume" ]; then
          echo ">>>> consume"
          php bin/console messenger:consume --all -vv

        # --------------------------------------------------------------------------------------------------------------
        # 3) stats
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "stats" ]; then
          echo ">>>> stats"
          php bin/console messenger:stats

        # --------------------------------------------------------------------------------------------------------------
        # 4) failed
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "failed" ]; then
          echo ">>>> failed"
          php bin/console messenger:failed:show --stats

        # --------------------------------------------------------------------------------------------------------------
        # 5) remove
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "remove" ]; then
          echo ">>>> remove"
          php bin/console messenger:failed:remove --all

        # --------------------------------------------------------------------------------------------------------------
        # 6) setup
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "setup" ]; then
          echo ">>>> setup"
          php bin/console messenger:setup-transports

        # --------------------------------------------------------------------------------------------------------------
        # 7) stop
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "stop" ]; then
          echo ">>>> stop"
          php bin/console messenger:stop-workers

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
