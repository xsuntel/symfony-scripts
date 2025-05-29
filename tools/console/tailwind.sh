#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Console Commands - Tailwindcss
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
cd "${PROJECT_PATH}" || exit

echo "---------------------------------------------------------------------------------------------------------------"
echo "[ Symfony ] Console Commands - Tailwindcss"
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
        select num in "build" "watch" "exit"; do
          case "$REPLY" in
          1)
            CONSOLE_COMMANDS="build"
            break
            ;;
          2)
            CONSOLE_COMMANDS="watch"
            break
            ;;
          3)
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
        # 1) build
        # --------------------------------------------------------------------------------------------------------------
        if [ "${CONSOLE_COMMANDS}" == "build" ]; then
          echo ">>>> build"
          symfony console tailwind:build

        # --------------------------------------------------------------------------------------------------------------
        # 2) watch
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "watch" ]; then
          echo ">>>> watch"
          symfony console tailwind:build --watch -v

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
