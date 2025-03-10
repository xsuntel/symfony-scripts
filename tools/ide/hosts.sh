#!/bin/bash
# ======================================================================================================================
# Tools - IDE - Status
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
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
  echo

  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_environment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_environment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_environment.sh" && exit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Hosts
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local PROJECT_HOST_NAME
      PROJECT_HOST_NAME=$(grep -i "symfony.local" /etc/hosts | awk '{print $2}' | head -n 1)
      if [ ! "${PROJECT_HOST_NAME}" ]; then
        echo $'\n127.0.0.1 symfony.local' | sudo tee -a /etc/hosts
        echo $'\n127.0.0.1 api.symfony.local' | sudo tee -a /etc/hosts
        echo $'\n127.0.0.1 cdn.symfony.local' | sudo tee -a /etc/hosts
        echo $'\n127.0.0.1 www.symfony.local' | sudo tee -a /etc/hosts
        echo
      fi
    fi

    echo ">>>> Hosts"
    echo
    sudo grep -v '#' /etc/hosts
    echo

  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Hosts
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local PROJECT_HOST_NAME
      PROJECT_HOST_NAME=$(grep -i "symfony.local" /etc/hosts | awk '{print $2}' | head -n 1)
      if [ ! "${PROJECT_HOST_NAME}" ]; then
        echo $'\n127.0.0.1 symfony.local' | sudo tee -a /etc/hosts
        echo $'\n127.0.0.1 api.symfony.local' | sudo tee -a /etc/hosts
        echo $'\n127.0.0.1 cdn.symfony.local' | sudo tee -a /etc/hosts
        echo $'\n127.0.0.1 www.symfony.local' | sudo tee -a /etc/hosts
        echo
      fi
    fi

    echo ">>>> Hosts"
    echo
    grep -v '#' /etc/hosts
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Hosts
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local PROJECT_HOST_NAME
      PROJECT_HOST_NAME=$(grep -i "symfony.local" /windows/system32/drivers/etc/hosts | awk '{print $2}' | head -n 1)
      if [ ! "${PROJECT_HOST_NAME}" ]; then
        Add-Content -Value "127.0.0.1 symfony.local" -Path /windows/system32/drivers/etc/hosts
        Add-Content -Value "127.0.0.1 api.symfony.local" -Path /windows/system32/drivers/etc/hosts
        Add-Content -Value "127.0.0.1 cdn.symfony.local" -Path /windows/system32/drivers/etc/hosts
        Add-Content -Value "127.0.0.1 www.symfony.local" -Path /windows/system32/drivers/etc/hosts
        echo
      fi
    fi

    echo ">>>> Hosts"
    echo
    grep -v '#' /windows/system32/drivers/etc/hosts
    echo

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

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
