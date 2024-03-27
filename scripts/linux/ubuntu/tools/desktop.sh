#!/bin/bash
# ======================================================================================================================
# Tools - Check this platform
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")")
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
  echo -n
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      # ----------------------------------------------------------------------------------------------------------------
      # Ubuntu
      # ----------------------------------------------------------------------------------------------------------------
      sudo rm -rf /var/lib/apt/lists/*
      sudo apt-get update -o Acquire::CompressionTypes::Order::=gz
      sudo apt-get update && sudo apt-get upgrade
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Kernel
      # ----------------------------------------------------------------------------------------------------------------
      echo "- PLATFORM Kernel : $(uname -r)"
      echo

      # >>>> Check kernel list
      local NOW_KERNEL_VERSION=$(uname -r | cut -d '-' -f 1,2)
      local DEL_KERNEL_VERSION=$(dpkg --list | grep linux-image- |grep -v linux-image-${OLD_KERNEL_VERSION} | grep -v linux-image-generic-hwe |awk  '{print $2}')

      if [ ${DEL_KERNEL_VERSION} ]; then
        dpkg --list | grep linux-image
        echo

        echo "sudo apt-get purge -y ${DEL_KERNEL_VERSION} -f"
        echo
      fi

      # ----------------------------------------------------------------------------------------------------------------
      # User
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Update a user permission
      if [ ! -f /etc/sudoers.d/$USER.conf ]; then
        sudo echo "${USER} ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
      else
        ls -ltr /etc/sudoers.d/$USER.conf
      fi

      # >>>> Remove some packages
      local delUserList="sync news uucp games"
      for userItem in ${delUserList}; do
        local USER_LIST
        USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
        if [ "${USER_LIST}" == ${userItem} ]; then
          sudo userdel ${userItem}
        fi
      done

      # ----------------------------------------------------------------------------------------------------------------
      # Firewall
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Import a firewall file
      if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/settings/firewall/_develop.sh ]; then
        source ${PROJECT_PATH}/scripts/linux/ubuntu/settings/firewall/_develop.sh
      else
        echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/settings/firewall/_develop.sh" && exit
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Packages
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Import a packages file
      if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/settings/_packages.sh ]; then
        source ${PROJECT_PATH}/scripts/linux/ubuntu/settings/_packages.sh
      else
        echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/settings/_packages.sh" && exit
      fi
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Services
      # ----------------------------------------------------------------------------------------------------------------
      # >>>> Import a services file
      if [ -f ${PROJECT_PATH}/scripts/linux/ubuntu/settings/_services.sh ]; then
        source ${PROJECT_PATH}/scripts/linux/ubuntu/settings/_services.sh
      else
        echo "Please check a file : ${PROJECT_PATH}/scripts/linux/ubuntu/settings/_services.sh" && exit
      fi
      echo

    fi

  else
    echo "Please check Operating System"
    setEnd
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

  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi
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

  # >>>> AWS - Import a CLI file
  if [ -f ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh ]; then
    source ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/base/_cli.sh" && exit
  fi
  echo

  # >>>> AWS - Import a Config file
  if [ -f ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh ]; then
    source ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/base/_config.sh" && exit
  fi
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

setGit() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - Git"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Global
  echo "# >>>>> Git - Config - Global"
  git config --global --list
  echo

  # >>>> Local
  echo "# >>>>> Git - Config - Local"
  git config --local --list
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
setGit

# >>>> End
setEnd
