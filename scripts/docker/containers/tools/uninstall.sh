#!/bin/bash
# ======================================================================================================================
# Tools - Docker Desktop - Uninstall
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
  source ${PROJECT_PATH}/scripts/base/_abstract.sh
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# ----------------------------------------------------------------------------------------------------------------------
# System Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Environment"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Select one of some environments
  PS3="Menu: "
  select num in "dev" "exit"; do
    case "$REPLY" in
    1)
      # >>>> DEV Environment
      ENVIRONMENT_NAME="dev"
      break
      ;;
    2)
      echo "exit()"
      setEnd
      ;;
    *)
      echo "[ ERROR ] Unknown Command"
      setEnd
      ;;
    esac
  done

  echo
  echo "- PROJECT ENV : ${ENVIRONMENT_NAME}"
  echo
}

# >>>> Platform

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PLATFORM OS : ${PLATFORM_TYPE}"
  echo
}

# >>>> Project

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${PROJECT_NAME}"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    echo "- CURRENT PATH : $(realpath ${PWD})"
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> PHP
    local PHP_PKG
    PHP_PKG=$(brew list | grep php)
    if [ "${PHP_PKG}" ]; then
      brew uninstall php@${PHP_VERSION}

      if [ -d /opt/homebrew/etc/php ]; then
        sudo rm -rf /opt/homebrew/etc/php
      fi
      echo
    fi

    # >>>> PHP Extension - PECL - Redis
    local PECL_STATUS
    PECL_STATUS=$(pecl list | awk '/redis/ {print $0}' | cut -c 1-6)
    if [ ${PECL_STATUS} ]; then
      pecl uninstall redis
      echo
    fi

    # >>>> PHP - Composer
    local PHP_COMPOSER
    PHP_COMPOSER=$(brew list | grep composer)
    if [ "${PHP_COMPOSER}" ]; then
      brew uninstall composer
      echo
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"
  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    echo "- CURRENT PATH : $(realpath ${PWD})"
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Redis
    local REDIS_PKG
    REDIS_PKG=$(brew list | grep redis)
    if [ "${REDIS_PKG}" ]; then
      brew uninstall redis

      if [ -f /opt/homebrew/etc/redis-sentinel.conf ]; then
        sudo rm -f /opt/homebrew/etc/redis-sentinel.conf
      fi
      if [ -f /opt/homebrew/etc/redis.conf ]; then
        sudo rm -f /opt/homebrew/etc/redis.conf
      fi
      if [ -f ~/Library/LanuchAgents/homebrew.mxcl.redis.plist ]; then
        sudo rm -f ~/Library/LanuchAgents/homebrew.mxcl.redis.plist
      fi
      echo
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"
  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"
}


# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - CDN"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Uninstall Docker Desktop on Ubuntu                               https://docs.docker.com/desktop/install/ubuntu/
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Docker Desktop - Prerequisites
      local delPackageList="docker-desktop"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" ]; then
          sudo apt purge -y ${pkgItem}
        fi
      done

      if [ -d $HOME/.docker/desktop ]; then
        rm -r $HOME/.docker/desktop
      fi
      if [ -f /usr/local/bin/com.docker.cli ]; then
        rm -f /usr/local/bin/com.docker.cli
      fi

      # >>>> Docker Desktop - Prerequisites - Options

      if [ -f ~/.config/systemd/user/docker-desktop.service ]; then
        rm -f ~/.config/systemd/user/docker-desktop.service
      fi

      if [ -f ~/.local/share/systemd/user/docker-desktop.service ]; then
        rm -f ~/.local/share/systemd/user/docker-desktop.service
      fi
      echo

      sudo apt autoremove -y

      # ----------------------------------------------------------------------------------------------------------------
      # Install Docker Desktop on Ubuntu     https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Docker Engine
      local delPackageList="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" ]; then
          sudo apt purge -y ${pkgItem}
        fi
      done

      if [ -d /var/lib/docker ]; then
        sudo rm -rf /var/lib/docker
      fi
      if [ -d /var/lib/containerd ]; then
        sudo rm -rf /var/lib/containerd
      fi
    fi
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"

    if [ -f /Library/LanuchDaemons/com.docker.socket.plist ]; then
      sudo rm -f /Library/LanuchDaemons/com.docker.socket.plist
    fi
    if [ -f /Library/LanuchDaemons/com.docker.vmnetd.plist ]; then
      sudo rm -f /Library/LanuchDaemons/com.docker.vmnetd.plist
    fi
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"
  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------

setGit() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - Git"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setIDE() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - IDE"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    echo "- CURRENT PATH : $(realpath ${PWD})"
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> PhpStorm
    if [ -d /Users/$USER/Library/Caches/JetBrains ]; then
      rm -rf /Users/$USER/Library/Caches/JetBrains
    fi

    # >>>> HomeBrew                                               https://github.com/homebrew/install#uninstall-homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
    if [ -d /opt/homebrew ]; then
      sudo rm -rf /opt/homebrew
    fi
    if [ -f ~/.zprofile ]; then
      rm -f ~/.zprofile
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"
  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

setWebBrowser() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - WebBrowser"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    echo "- CURRENT PATH : $(realpath ${PWD})"
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Fireforx
    if [ -d /Users/$USER/Library/Caches/Mozilla ]; then
      rm -rf /Users/$USER/Library/Caches/Mozilla
    fi
    if [ -d /Users/$USER/Library/Caches/Firefox ]; then
      rm -rf /Users/$USER/Library/Caches/Firefox
    fi

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"
  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ======================================================================================================================
# START
# ======================================================================================================================

# >>>> Start
setStart

# ----------------------------------------------------------------------------------------------------------------------
# System Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment
setEnvironment

# >>>> Platform
setPlatform

# >>>> Project
setProject

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
setPhp

# >>>> Cache
setRedis

# >>>> Database
#setPostgreSQL

# >>>> Server
#setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------
#setVM

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------
#setGit

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
