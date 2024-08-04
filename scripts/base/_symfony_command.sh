#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Command Line Interface                                                https://symfony.com/download
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
  # Platform - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Symfony CLI
  if [ ! -f /opt/homebrew/opt/symfony-cli/bin/symfony ]; then
    (
      cd ~/Downloads || return

      curl -sS https://get.symfony.com/cli/installer | bash
      brew install symfony-cli/tap/symfony-cli
      echo
    )
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