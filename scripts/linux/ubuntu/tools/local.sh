#!/bin/bash
# ======================================================================================================================
# Tools - Check this platform in Dev Environment
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")")
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
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # ----------------------------------------------------------------------------------------------------------------
    # Boot
    # ----------------------------------------------------------------------------------------------------------------


    # ----------------------------------------------------------------------------------------------------------------
    # Firewall
    # ----------------------------------------------------------------------------------------------------------------
    # >>>> Import a firewall file
    if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_firewall.sh ]; then
      source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_firewall.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_firewall.sh" && exit
    fi
    echo

    # ----------------------------------------------------------------------------------------------------------------
    # Hosts
    # ----------------------------------------------------------------------------------------------------------------
    # >>>> Import a host file
    if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_hosts.sh ]; then
      source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_hosts.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_hosts.sh" && exit
    fi
    echo

    # ----------------------------------------------------------------------------------------------------------------
    # Kernel
    # ----------------------------------------------------------------------------------------------------------------
    # >>>> Import a kernel file
    if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_kernel.sh ]; then
      source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_kernel.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_kernel.sh" && exit
    fi
    echo

    # ----------------------------------------------------------------------------------------------------------------
    # Packages
    # ----------------------------------------------------------------------------------------------------------------
    # >>>> Import a packages file
    if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_packages.sh ]; then
      source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_packages.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_packages.sh" && exit
    fi
    echo

    # ----------------------------------------------------------------------------------------------------------------
    # Services
    # ----------------------------------------------------------------------------------------------------------------
    # >>>> Import a services file
    if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_services.sh ]; then
      source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_services.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_services.sh" && exit
    fi
    echo

    # ----------------------------------------------------------------------------------------------------------------
    # User
    # ----------------------------------------------------------------------------------------------------------------
    # >>>> Update a user permission
    if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_user.sh ]; then
      source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_user.sh
    else
      echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_user.sh" && exit
    fi
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
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

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache"
  echo "---------------------------------------------------------------------------------------------------------------"
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

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Check Hardware
  echo ">>>> CPU"
  top -b -n 1 | head -n 5
  echo

  echo ">>>> Memory"
  free -m
  echo

  echo ">>>> SSD"
  df -h
  echo

  echo ">>>> Network"
  netstat -napo | grep -i time_wait
  echo

  echo ">>>> Temp files"
  if [ -d /tmp ]; then
    sudo rm -rfv /tmp/*
  fi

  if [ -d /home/${LOGNAME}/.cache ]; then
    sudo rm -rf /home/${LOGNAME}/.cache/*
  fi
  echo

  # >>>> Import a services file
  if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_process.sh ]; then
    source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_process.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_process.sh" && exit
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
#setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
