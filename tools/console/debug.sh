#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Console Commands - Debug
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
cd "${PROJECT_PATH}" || exit

echo "---------------------------------------------------------------------------------------------------------------"
echo "[ Symfony ] Console Commands - Debug"
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
        select num in "config" "dotenv" "router" "autowiring" "container" "serializer" "validator" "asset-map" ; do
          case "$REPLY" in
          1)
            CONSOLE_COMMANDS="config"
            break
            ;;
          2)
            CONSOLE_COMMANDS="dotenv"
            break
            ;;
          3)
            CONSOLE_COMMANDS="router"
            break
            ;;
          4)
            CONSOLE_COMMANDS="autowiring"
            break
            ;;
          5)
            CONSOLE_COMMANDS="container"
            break
            ;;
          6)
            CONSOLE_COMMANDS="serializer"
            break
            ;;
          7)
            CONSOLE_COMMANDS="validator"
            break
            ;;
          8)
            CONSOLE_COMMANDS="asset-map"
            break
            ;;
          9)
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
        # 1) config
        # ----------------------------------------------------------------------------------------------------------------
        if [ "${CONSOLE_COMMANDS}" == "config" ]; then
          echo ">>>> config"
          php bin/console debug:config

        # ----------------------------------------------------------------------------------------------------------------
        # 2) dotenv
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "dotenv" ]; then
          echo ">>>> dotenv"
          php bin/console debug:dotenv

        # ----------------------------------------------------------------------------------------------------------------
        # 3) router
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "router" ]; then
          echo ">>>> router"
          php bin/console debug:router

        # ----------------------------------------------------------------------------------------------------------------
        # 4) autowiring
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "autowiring" ]; then
          echo ">>>> autowiring"
          php bin/console debug:autowiring

        # ----------------------------------------------------------------------------------------------------------------
        # 5) container
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "container" ]; then
          echo ">>>> container"
          php bin/console debug:container

        # ----------------------------------------------------------------------------------------------------------------
        # 6) serializer
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "serializer" ]; then
          echo ">>>> serializer"
          php bin/console debug:serializer

        # ----------------------------------------------------------------------------------------------------------------
        # 7) validator
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "validator" ]; then
          echo ">>>> validator"
          php bin/console debug:validator

        # ----------------------------------------------------------------------------------------------------------------
        # 8) asset-map
        # ----------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "asset-map" ]; then
          echo ">>>> asset-map"
          php bin/console debug:container

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
