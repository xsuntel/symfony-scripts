#!/bin/bash

#set -euo pipefail
# ----------------------------------------------------------------------------------------------------------------------
# Scripts - Deploy - Dev - Windows - WSL - Deploy
# ----------------------------------------------------------------------------------------------------------------------

find_project_root() {
    local PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    while [[ "${PROJECT_DIR}" != "/" ]]; do
        if [[ -d "${PROJECT_DIR}/.git" ]] || [[ -f "${PROJECT_DIR}/.env.app" ]]; then
            echo "${PROJECT_DIR}"
            return 0
        fi
        PROJECT_DIR="$(dirname "${PROJECT_DIR}")"
    done
    return 1
}

PROJECT_PATH=$(find_project_root)
PROJECT_NAME=$(basename "$(realpath "${PROJECT_PATH}")")
cd "${PROJECT_PATH}" || exit

# ----------------------------------------------------------------------------------------------------------------------
# Abstract
# ----------------------------------------------------------------------------------------------------------------------

if [ -f "${PROJECT_PATH}/scripts/base/_abstract.sh" ]; then
  source "${PROJECT_PATH}/scripts/base/_abstract.sh"
else
  echo "Please check a file : ./scripts/base/_abstract.sh" && exit
fi

# >>>> Environment

if [ "${PLATFORM_TYPE}" != "Linux" ]; then
  echo
  echo "Please check Operating System"
  setExit
fi

# >>>> WSL2 kernel is tagged "-microsoft-standard-WSL2" — block native Ubuntu machines
if ! grep -qi "microsoft" /proc/sys/kernel/osrelease; then
  echo
  echo "Please check WSL2 Environment"
  setExit
fi

# >>>> The systemctl calls below require systemd as PID 1 — WSL2 needs systemd=true in /etc/wsl.conf
if [ ! -d /run/systemd/system ]; then
  echo
  echo "Please enable systemd : set 'systemd=true' under [boot] in /etc/wsl.conf, then run 'wsl --shutdown'"
  setExit
fi

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PLATFORM_TYPE} - ${PLATFORM_PROCESSOR}"
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
}

# >>>> Platform

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      # >>>> User - Permission
      if [ ! -f "/etc/sudoers.d/${USER}" ]; then
        echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/${USER}" > /dev/null
        sudo chmod 0440 "/etc/sudoers.d/${USER}"
        # A broken sudoers.d file locks out sudo entirely — validate before keeping it
        if ! sudo visudo -cf "/etc/sudoers.d/${USER}"; then
          sudo rm -f "/etc/sudoers.d/${USER}"
          echo "Please check a file : /etc/sudoers.d/${USER}" && setExit
        fi
        echo
      fi

      # >>>> WSL2 kernel is managed by Windows (wsl --update) — no dpkg kernel packages, no GRUB
      echo ">>>> Linux - kernel : $(uname -r)"
      echo

      sudo systemctl daemon-reload
      echo
    fi
  fi

  # >>>> Linux - Base

  if [ -f "${PROJECT_PATH}/scripts/base/_platform.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/_platform.sh"
  else
    echo "Please check a file : ./scripts/base/_platform.sh" && exit
  fi

  # >>>> Linux - Network

  if [ -f "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/network/_hosts.sh" ]; then
    source "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/network/_hosts.sh"
  else
    echo "Please check a file : ./scripts/deploy/dev/windows/wsl/network/_hosts.sh" && exit
  fi
  echo

  # >>>> Linux - Packages

  if [ -f "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/packages/_base.sh" ]; then
    source "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/packages/_base.sh"
  else
    echo "Please check a file : ./scripts/deploy/dev/windows/wsl/packages/_base.sh" && exit
  fi
  echo

  if [ -f "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/packages/_network.sh" ]; then
    source "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/packages/_network.sh"
  else
    echo "Please check a file : ./scripts/deploy/dev/windows/wsl/packages/_network.sh" && exit
  fi
  echo

  if [ -f "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/packages/_ubuntu_pro.sh" ]; then
    source "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/packages/_ubuntu_pro.sh"
  else
    echo "Please check a file : ./scripts/deploy/dev/windows/wsl/packages/_ubuntu_pro.sh" && exit
  fi
  echo

  # >>>> Linux - Security

  if [ -f "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/security/_directories.sh" ]; then
    source "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/security/_directories.sh"
  else
    echo "Please check a file : ./scripts/deploy/dev/windows/wsl/security/_directories.sh" && exit
  fi
  echo

  if [ -f "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/security/_files.sh" ]; then
    source "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/security/_files.sh"
  else
    echo "Please check a file : ./scripts/deploy/dev/windows/wsl/security/_files.sh" && exit
  fi
  echo

  if [ -f "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/security/_users.sh" ]; then
    source "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/security/_users.sh"
  else
    echo "Please check a file : ./scripts/deploy/dev/windows/wsl/security/_users.sh" && exit
  fi
  echo

  # >>>> Linux - Utility

  if [ -f "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/utility/_crontab.sh" ]; then
    source "${PROJECT_PATH}/scripts/deploy/dev/windows/wsl/utility/_crontab.sh"
  else
    echo "Please check a file : ./scripts/deploy/dev/windows/wsl/utility/_crontab.sh" && exit
  fi
  echo

  sudo apt-get autoremove -y && sudo apt-get autoclean -y
  echo
}

# >>>> Project

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Project : ${PROJECT_NAME}"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Git
  if [ -f "${PROJECT_PATH}/scripts/base/utility/git/base/_config.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/utility/git/base/_config.sh"
  else
    echo "Please check a file : ./scripts/base/utility/git/base/_config.sh" && exit
  fi

  # >>>> Directory
  if [ -f "${PROJECT_PATH}/scripts/base/_project.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/_project.sh"
  else
    echo "Please check a file : ./scripts/base/_project.sh" && exit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - App - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP
  if [ -f "${PROJECT_PATH}"/scripts/base/app/php/base/_install.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/app/php/base/_install.sh
  else
    echo "Please check a file : ./scripts/base/app/php/base/_install.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Command Line Interface
  if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/base/_command.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/app/symfony/base/_command.sh
  else
    echo "Please check a file : ./scripts/base/app/symfony/base/_command.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Components
  if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/base/_components.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/app/symfony/base/_components.sh
  else
    echo "Please check a file : ./scripts/base/app/symfony/base/_components.sh" && exit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Cache - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Database - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Message

setRabbitMQ() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Message - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Base - Server - Packages"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Build Scripts
# ----------------------------------------------------------------------------------------------------------------------

setBuild() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Build"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP - Symfony Framework - Deployment
  if [ -f "${PROJECT_PATH}/scripts/base/app/symfony/base/_deployment.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/app/symfony/base/_deployment.sh"
  else
    echo "Please check a file : ./scripts/base/app/symfony/base/_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Permissions - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Database    - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Cron jobs   - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Back-End  - Messenger   - (Optional)


  # >>>> PHP - Symfony Framework - Deployment - Front-End - AssetMapper - (Optional)
  if [ -f "${PROJECT_PATH}/scripts/base/app/symfony/common/assets/_assetmapper.sh" ]; then
    source "${PROJECT_PATH}/scripts/base/app/symfony/common/assets/_assetmapper.sh"
  else
    echo "Please check a file : ./scripts/base/app/symfony/common/assets/_assetmapper.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Docker - Containers"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Docker
  if [ -f "${PROJECT_PATH}"/scripts/base/utility/docker/base/_install.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/utility/docker/base/_install.sh
  else
    echo "Please check a file : ./scripts/base/utility/docker/base/_install.sh" && exit
  fi
  echo

  # >>>> Docker - Containers
  if [ -f "${PROJECT_PATH}"/scripts/base/utility/docker/base/_deploy.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/utility/docker/base/_deploy.sh
  else
    echo "Please check a file : ./scripts/base/utility/docker/base/_deploy.sh" && exit
  fi
  echo

  echo ">>>> Docker - System Disk Usage"
  echo

  docker system df
  echo

  echo ">>>> Docker - Running Containers"
  echo

  docker ps
  echo

  sudo lsof -i | grep docker-pr
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Providers ( Cloud Service Provider )
# ----------------------------------------------------------------------------------------------------------------------

setProvider() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Providers ( Cloud Service Provider )"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# ----------------------------------------------------------------------------------------------------------------------
# Utility
# ----------------------------------------------------------------------------------------------------------------------

setUtility() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Utility"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> PHP - Symfony Framework - Server
  if [ -f "${PROJECT_PATH}"/scripts/base/app/symfony/base/_local_server.sh ]; then
    source "${PROJECT_PATH}"/scripts/base/app/symfony/base/_local_server.sh
  else
    echo "Please check a file : ./scripts/base/app/symfony/base/_local_server.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Tools - VM ( Instance )
# ----------------------------------------------------------------------------------------------------------------------

setTools() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ${ENVIRONMENT_NAME} ] ${PLATFORM_TYPE} - Tools - VM ( Instance )"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      hostnamectl
      echo

      echo ">>>> ${PLATFORM_TYPE} - Process"
      echo

      # >>>> Cron
      local CRON_STATUS
      CRON_STATUS=$(systemctl is-active cron)
      if [ "${CRON_STATUS}" == "inactive" ]; then
        sudo systemctl start cron
        sudo systemctl status cron --no-pager
        echo
      fi
      echo "Cron       : ${CRON_STATUS}"
      echo

      # >>>> Rsyslog
      local RSYSLOG_STATUS
      RSYSLOG_STATUS=$(systemctl is-active rsyslog)
      if [ "${RSYSLOG_STATUS}" == "inactive" ]; then
        sudo systemctl start rsyslog
        sudo systemctl status rsyslog --no-pager
        echo
      fi
      echo "Rsyslog    : ${RSYSLOG_STATUS}"
      echo

      echo ">>>> ${PLATFORM_TYPE} - Network"
      echo

      # >>>> Hardware
      netstat -r
      echo

      sudo ss -tulpn
      echo

      # >>>> User
      echo ">>>> ${PLATFORM_TYPE} - Users"
      echo

      if [ -f "/etc/sudoers.d/${USER}" ]; then
        sudo rm -fv "/etc/sudoers.d/${USER}"
      fi

    fi

  fi
  echo

  echo ">>>> ${PLATFORM_TYPE} - IDE : AI"
  echo

  # >>>> Tools - AI - Claude Code - Scheduler
  if [ -f "${PROJECT_PATH}/tools/ai/anthropic/claude/scheduler/_base.sh" ]; then
    source "${PROJECT_PATH}/tools/ai/anthropic/claude/scheduler/_base.sh"
  else
    echo "Please check a file : ./tools/ai/anthropic/claude/scheduler/_base.sh"
  fi
  echo

}

# ----------------------------------------------------------------------------------------------------------------------
# START
# ----------------------------------------------------------------------------------------------------------------------

setStart

# ----------------------------------------------------------------------------------------------------------------------
# Abstract
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment
setEnvironment

# >>>> Platform
setPlatform

# >>>> Project
setProject

# ----------------------------------------------------------------------------------------------------------------------
# Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
setPhp

# >>>> Cache
#setRedis

# >>>> Database
#setPostgreSQL

# >>>> Message
#setRabbitMQ

# >>>> Server
#setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Build Scripts
# ----------------------------------------------------------------------------------------------------------------------
setBuild

# ----------------------------------------------------------------------------------------------------------------------
# Docker - Containers
# ----------------------------------------------------------------------------------------------------------------------
setDocker

# ----------------------------------------------------------------------------------------------------------------------
# Providers ( Cloud Service Provider )
# ----------------------------------------------------------------------------------------------------------------------
#setProvider

# ----------------------------------------------------------------------------------------------------------------------
# Utility
# ----------------------------------------------------------------------------------------------------------------------
setUtility

# ----------------------------------------------------------------------------------------------------------------------
# Tools - VM ( Instance )
# ----------------------------------------------------------------------------------------------------------------------
setTools

# ----------------------------------------------------------------------------------------------------------------------
# END
# ----------------------------------------------------------------------------------------------------------------------

setEnd
