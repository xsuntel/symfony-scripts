#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Console Commands - Mailer
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
cd "${PROJECT_PATH}" || exit

echo "---------------------------------------------------------------------------------------------------------------"
echo "[ Symfony ] Console Commands - Mailer"
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
        select num in "test"; do
          case "$REPLY" in
          1)
            CONSOLE_COMMANDS="test"
            break
            ;;
          2)
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

        # ----------------------------------------------------------------------------------------------------------------
        # 1) test
        # ----------------------------------------------------------------------------------------------------------------
        if [ "${CONSOLE_COMMANDS}" == "test" ]; then
          echo ">>>> test"
          php bin/console mailer:test someone@example.com

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