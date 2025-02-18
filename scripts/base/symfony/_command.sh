#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Symfony - Command Line Interface                                         https://symfony.com/download
# ======================================================================================================================

echo ">>>> PHP - Symfony - Command"
echo

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux - Ubuntu
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Symfony CLI
  if [ ! -f /bin/symfony ]; then
    (
      cd /tmp || return

      curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | sudo -E bash
      sudo apt install symfony-cli
      echo
    )
  fi

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - MacOS                           https://symfony.com/doc/current/setup/symfony_server.html#getting-started
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Symfony CLI
  if [ ! -f /usr/local/bin/symfony ]; then
    (
      cd ~/Downloads || return

      curl -sS https://get.symfony.com/cli/installer | bash
      echo
    )

    sudo mv /Users/rlim/.symfony5/bin/symfony /usr/local/bin/symfony

    sudo codesign --force --deep --sign - $(whereis -q symfony)
  fi

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Symfony CLI
  if [ ! -f "C:\Program Files\Symfony\symfony.exe" ]; then
    # >>>> Scoop
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
    # >>>> Symfony-CLI
    scoop install symfony-cli
  fi

else
  echo "Please check Operating System"
  setExit
fi

# ----------------------------------------------------------------------------------------------------------------------
# Local Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
if [ -d app ]; then
  (
    cd app || return

    # >>>> Symfony Framework
    if [ -f bin/console ]; then

      # >>>> Symfony CLI - PHP
      symfony local:php:list

    else
      echo "[ ERROR ] There is not a command : app/bin/console"
      setExit
    fi
  )
fi