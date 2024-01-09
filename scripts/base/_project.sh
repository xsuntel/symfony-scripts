#!/bin/bash
# ======================================================================================================================
# Scripts - Project
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Linux - Ubuntu
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Permission
  if [ -d app ]; then
    sudo chown "$(whoami)":"$(whoami)" -R ./app
  fi

  # >>>> Symfony CLI                                                                        https://symfony.com/download
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
  # MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Permission
  if [ -d app ]; then
    chown "$(whoami)": ./app
  fi

  # >>>> Symfony CLI                                                                        https://symfony.com/download
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
  # Windows
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Permission
  if [ -d app ]; then
    chown "$(whoami)":"$(whoami)" -R ./app
  fi

  # >>>> Symfony CLI                                                                        https://symfony.com/download
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

# >>>> Project
if [ -d app ]; then
  (
    cd app || return

    # >>>> Git - User                                                                              https://git-scm.com/
    git config --global user.name "${GIT_CONFIG_GLOBAL_USER_NAME}"
    git config --global user.email "${GIT_CONFIG_GLOBAL_USER_EMAIL}"

    # >>>> Git - Config - Global
    git config --global init.defaultBranch main
    git config --global core.editor vi
    git config --global core.autocrlf false
    git config --global color.ui true
    git config --global diff.ui auto
    git config --global format.pretty oneline
    git config --global push.default simple

    git config --global credential.helper store

    local GIT_SAFE_DIRECTORY
    GIT_SAFE_DIRECTORY=$(git config --global --list | grep -i "${PROJECT_PATH}")
    if [ ! "${GIT_SAFE_DIRECTORY}" ]; then
      git config --global --add safe.directory "${PROJECT_PATH}"
    fi
  )
else
  echo
  echo "[ ERROR ] There is not a folder : app"
fi

# ----------------------------------------------------------------------------------------------------------------------
# App
# ----------------------------------------------------------------------------------------------------------------------
# >>>> Application
if [ -d app ]; then
  (
    cd app || return

    # >>>> Remove cache files
    if [ -d var ]; then
      sudo rm -rf var/*
      mkdir -p var/cache
      mkdir -p var/log
      mkdir -p var/sessions
      mkdir -p var/translations
    else
      mkdir -p var
      mkdir -p var/cache
      mkdir -p var/log
      mkdir -p var/sessions
      mkdir -p var/translations
    fi

    sudo chmod 777 var
  )
else
  echo
  echo "[ ERROR ] There is not a folder : app"
fi

# >>>> Node
if [ -d node_modules ]; then
  rm -rf node_modules
fi

# >>>> Files
find ./ -name "composer.phar" -exec rm -fv {} \;
find ./ -name "phing-latest.phar" -exec rm -fv {} \;

# ----------------------------------------------------------------------------------------------------------------------
# Scripts
# ----------------------------------------------------------------------------------------------------------------------
# >>>> Docker Desktop - Containers - Logs
if [ -d var ]; then
  rm -rf var
fi

# >>>> Tests
if [ -d tests ]; then
  rm -rf tests
fi
if [ -d test ]; then
  rm -rf test
fi

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------
# >>>> Python - Virtual Environment
if [ -d vendor ]; then
  rm -rf vendor
fi
if [ -d .vendor ]; then
  rm -rf .vendor
fi

# >>>> Files
find ./ -name ".DS_Store" -type f -exec rm -f {} \;
find ./ -name ".DS_Store" -type d -exec rm -rf {} \;

find ./ -name "sudo" -type f -exec rm -rf {} \;