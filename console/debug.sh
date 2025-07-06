#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Console Commands - Debug
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$0")")
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
        select num in "config" "dotenv" "firewall" "autowiring" "container" "exit"; do
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
            CONSOLE_COMMANDS="firewall"
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
        # 1) config
        # --------------------------------------------------------------------------------------------------------------
        if [ "${CONSOLE_COMMANDS}" == "config" ]; then
          echo ">>>> config"
          symfony console debug:config

        # --------------------------------------------------------------------------------------------------------------
        # 2) dotenv
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "dotenv" ]; then
          echo ">>>> dotenv"
          symfony console debug:dotenv

        # --------------------------------------------------------------------------------------------------------------
        # 3) firewall
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "firewall" ]; then
          echo ">>>> firewall"
          symfony console debug:firewall main

        # --------------------------------------------------------------------------------------------------------------
        # 4) autowiring
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "autowiring" ]; then
          echo ">>>> autowiring"
          symfony console debug:autowiring --all

        # --------------------------------------------------------------------------------------------------------------
        # 5) container
        # --------------------------------------------------------------------------------------------------------------
        elif [ "${CONSOLE_COMMANDS}" == "container" ]; then
          echo ">>>> container"
          symfony console debug:container

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
