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
      # >>>> Dev Environment
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
}

setNode() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - Node"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Cache

setMemcached() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Memcached"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Database

setMongoDB() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - MongoDB"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setMySQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - MySQL"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setApache() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server - Apache"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Scripts
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
      # Add Docker's official GPG key:
      sudo apt-get update -y
      local addPackageList="ca-certificates curl gnupg"
      for pkgItem in ${addPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt-get install -y ${pkgItem}
          echo
        fi
      done

      if [ -d /etc/apt/keyrings ]; then
        sudo install -m 0755 -d /etc/apt/keyrings
      fi
      if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
      fi
      echo

      # Add the repository to Apt sources:
      echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update -y
      echo

      local addPackageList="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
      for pkgItem in ${addPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt-get install -y ${pkgItem}
          echo
        fi
      done

      # ----------------------------------------------------------------------------------------------------------------
      # Install Docker Desktop on Ubuntu     https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Credentials management for Linux users
      if [ ! -d ~/.password-store ]; then
        firefox --new-tab https://docs.docker.com/desktop/get-started/#credentials-management-for-linux-users

        gpg --generate-key
      fi

      # >>>> Install Docker Desktop
      local DOCKER_DESKTOP_STATUS
      DOCKER_DESKTOP_STATUS=$(systemctl is-active docker-desktop)
      if [ "${DOCKER_DESKTOP_STATUS}" == "inactive" ]; then
        firefox --new-tab https://docs.docker.com/desktop/install/ubuntu/#install-docker-desktop
        echo

        systemctl --user enable docker-desktop

        systemctl --user start docker-desktop
      fi
    fi
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
}

setWebBrowser() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - WebBrowser"
  echo "---------------------------------------------------------------------------------------------------------------"
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
#setPhp

# >>>> Cache
#setRedis

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
