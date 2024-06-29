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
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Ubuntu
      # ----------------------------------------------------------------------------------------------------------------
      sudo apt-get update -y
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
      # User
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Update a user permission
      if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_user.sh ]; then
        source ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_user.sh
      else
        echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/tools/settings/_user.sh" && exit
      fi
      echo

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

    fi

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

  # >>>> Platform
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    # ----------------------------------------------------------------------------------------------------------------
    # Hardware
    # ----------------------------------------------------------------------------------------------------------------
    # >>>> Check status
    echo ">>>> CPU"
    top -b -n 1 | head -n 5
    echo

    echo ">>>> Memory"
    sudo sysctl -w vm.min_free_kbytes=2000000                                                           # default :16384
    sudo sysctl -w vm.vfs_cache_pressure=10000                                                          # default : 100
    sudo sysctl -w vm.drop_caches=2
    sudo sysctl -w vm.swappiness=0
    echo

    echo 2 > sudo /proc/sys/vm/drop_caches
    echo 0 > sudo /proc/sys/vm/swappiness
    sudo swapoff -a && sudo swapon -a
    free -m
    echo

    sudo slabtop -o | grep dentry
    echo

    cat /proc/meminfo | grep -i anon
    echo

    echo ">>>> SSD"
    df -h
    echo

    echo ">>>> Network"
    # >>>> Network - ipv6
    sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
    sudo cat /proc/sys/net/ipv6/conf/all/disable_ipv6
    echo

    netstat -napo | grep -i time_wait
    echo

    echo ">>>> Temp files"
    if [ -d /tmp ]; then
      sudo rm -rf /tmp/*
    fi

    if [ -d /home/${LOGNAME}/.cache ]; then
      sudo rm -rf /home/${LOGNAME}/.cache/*
    fi
    echo
  fi
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
