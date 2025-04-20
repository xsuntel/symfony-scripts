#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Console Commands - Twig
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
cd "${PROJECT_PATH}" || exit

echo "---------------------------------------------------------------------------------------------------------------"
echo "[ Symfony ] Console Commands - Twig"
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
        select num in "twig" "twig-component" "exit"; do
          case "$REPLY" in
          1)
            CONSOLE_COMMANDS="twig"
            break
            ;;
          2)
            CONSOLE_COMMANDS="twig-component"
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
        # 1) twig
        # --------------------------------------------------------------------------------------------------------------
        if [ "${CONSOLE_COMMANDS}" == "twig" ]; then
          echo ">>>> twig"
          php bin/console debug:twig

        # --------------------------------------------------------------------------------------------------------------
        # 2) twig-component
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "twig-component" ]; then
          echo ">>>> twig-component"
          php bin/console debug:twig-component

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
