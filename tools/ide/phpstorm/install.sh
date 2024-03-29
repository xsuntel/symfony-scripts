#!/bin/bash
# ======================================================================================================================
# Tools - IDE - PhpStorm - Install
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
  source ${PROJECT_PATH}/scripts/base/_abstract.sh
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# >>>> Environment

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
# Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - PostgreSQL"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server - Nginx"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Cloud"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # >>>> Install required packages
      local addPackageList="open-vm-tools"
      for pkgItem in ${addPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
          sudo apt install -y ${pkgItem}
          echo
        fi
      done
    fi

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      echo -n
    fi
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      echo -n
    fi
  else
    echo "Please check Operating System"
    setEnd
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------

setIDE() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - IDE - PhpStorm"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # >>>> Java
      echo "- Java"
      local JAVA_VERSION
      JAVA_VERSION=$(java -version 2>&1 | head -1 | awk -F '_|"' '{print $2}' | cut -c 1-2)
      if [ "${JAVA_VERSION}" == "${OPENJDK_VERSION}" ]; then
        echo "OpenJDK has been installed"
      else
        sudo apt install -y openjdk-${OPENJDK_VERSION}-jdk
      fi
      java -version
      echo

      # >>>> PhpStorm
      echo "- PhpStorm"
      local PHPSTORM_STATUS
      #PHPSTORM_STATUS=$(sudo find /opt -type d -name "^PhpStorm*" -print 2>/dev/null)
      PHPSTORM_STATUS=$(ls -d /opt/PhpStorm* 2>&1 | head -1 | cut -c 6-13)
      if [ "${PHPSTORM_STATUS}" != "PhpStorm" ]; then
        (
          cd /tmp || return

          # >>>> Process
          if [ "${PROCESSOR_TYPE}" == "x86_64" ]; then

            echo "Downloading from a remote site"
            wget https://download.jetbrains.com/webide/PhpStorm-${PHPSTORM_VERSION}.tar.gz -P /tmp
            echo

            echo "Unzip : PhpStorm-${PHPSTORM_VERSION}.tar.gz"
            echo

            if [ -d /opt ]; then
              sudo tar -xzf PhpStorm-${PHPSTORM_VERSION}.tar.gz -C /opt
              #chown -R "$(id -u)":"$(id -g)" /opt
              sudo chown "$(whoami)":"$(whoami)" -R /opt
              ls -ltr /opt
              echo
            fi
            sudo rm -fv PhpStorm-${PHPSTORM_VERSION}.tar.gz

          else
            echo "Downloading from a remote site"
            wget https://download.jetbrains.com/webide/PhpStorm-${PHPSTORM_VERSION}-${PROCESSOR_TYPE}.tar.gz -P /tmp
            echo

            echo "Unzip : PhpStorm-${PHPSTORM_VERSION}-${PROCESSOR_TYPE}.tar.gz"
            echo

            if [ -d /opt ]; then
              sudo tar -xzf PhpStorm-${PHPSTORM_VERSION}-${PROCESSOR_TYPE}.tar.gz -C /opt
              #chown -R "$(id -u)":"$(id -g)" /opt
              sudo chown "$(whoami)":"$(whoami)" -R /opt
              ls -ltr /opt
              echo
            fi
            sudo rm -fv PhpStorm-${PHPSTORM_VERSION}-${PROCESSOR_TYPE}.tar.gz

          fi
          # >>>> PhpStorm - Settings - PHP - Servers - Name : symfony
          #PHP_IDE_CONFIG=serverName=symfony
          #echo "PhpStorm - Settings - PHP - Servers - Name : symfony"
          echo

          echo "To create a desktop entry, do one of the following: From the main menu, click Tools | Create Desktop Entry"
          echo
        )
      else
        echo "PhpStorm has been installed"
        echo
      fi
    fi
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      echo -n
    fi
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      echo -n
    fi
  else
    echo "Please check Operating System"
    setEnd
  fi
  echo
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
# Web Server
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
# Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------
#setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------
setIDE

# >>>> End
setEnd
