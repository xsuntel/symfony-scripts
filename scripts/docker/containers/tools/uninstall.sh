#!/bin/bash
# ======================================================================================================================
# Tools - Docker Desktop - Uninstall
# ======================================================================================================================
# >>>> Base
PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
cd "${PROJECT_PATH}" || exit
if [ -f ${PROJECT_PATH}/.env ]; then
  # >>>> Import .env file
  source ${PROJECT_PATH}/.env
  # >>>> Import a abstract file
  if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_abstract.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
  fi
else
  echo "Please check .env file : ${PROJECT_PATH}/.env" && exit
fi

# ----------------------------------------------------------------------------------------------------------------------
# Environment
# ----------------------------------------------------------------------------------------------------------------------

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE}"
  echo "---------------------------------------------------------------------------------------------------------------"
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

# ----------------------------------------------------------------------------------------------------------------------
# Platform
# ----------------------------------------------------------------------------------------------------------------------

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PLATFORM OS : ${PLATFORM_TYPE}"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # >>>> Install gnome-terminal
      sudo apt install -y gnome-terminal
    fi
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Project
# ----------------------------------------------------------------------------------------------------------------------

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${ABSTRACT_NAME}"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# App
# ----------------------------------------------------------------------------------------------------------------------

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setNode() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - Node"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Cache
# ----------------------------------------------------------------------------------------------------------------------

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Database
# ----------------------------------------------------------------------------------------------------------------------

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - PostgreSQL"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Server
# ----------------------------------------------------------------------------------------------------------------------

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server - Nginx"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Scripts
# ----------------------------------------------------------------------------------------------------------------------

setCloud() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Cloud"
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
  fi
  echo
}

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
}

setWebBrowser() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - WebBrowser"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ======================================================================================================================
# Main
# ======================================================================================================================

# >>>> Start
setStart

# >>>> Environment
setEnvironment

# >>>> Platform
setPlatform

# >>>> Project
setProject

# ----------------------------------------------------------------------------------------------------------------------
# >>>> App - PHP Framework - Symfony
# ----------------------------------------------------------------------------------------------------------------------
#setPhp
#setNode

# >>>> Cache
#setRedis

# >>>> Database
#setPostgreSQL

# >>>> Server
#setNginx

# ----------------------------------------------------------------------------------------------------------------------
# >>>> Scripts
# ----------------------------------------------------------------------------------------------------------------------
#setCloud
setDocker
#setVM

# ----------------------------------------------------------------------------------------------------------------------
# >>>> Tools
# ----------------------------------------------------------------------------------------------------------------------
#setGit
#setIDE
#setWebBrowser

# >>>> End
setEnd
