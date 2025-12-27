#!/bin/bash
# ======================================================================================================================
# Scripts - Base - App - Supervisor
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux - Ubuntu
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Supervisor

  echo ">>>> Linux - Process - Supervisor"
  echo

  # >>>> Supervisor - Install required packages
  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(dpkg -l | grep -i "supervisor" | awk '{print $2}' | cut -d ':' -f1 | awk "/^supervisor$/")
  if [ "${SUPERVISOR_STATUS}" != "supervisor" ]; then
    sudo apt-get install -y supervisor
    echo
  fi

  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.conf /etc/supervisor/conf.d/messenger-worker.conf
    echo
  fi

  # >>>> Supervisor - Start process
  sudo supervisorctl reread
  echo

  sudo supervisorctl update
  echo

  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
    sudo supervisorctl start messenger-consume:*
    echo
  else
    sudo supervisorctl stop messenger-consume:*
    echo
  fi

  sudo supervisorctl status
  echo


elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - MacOS
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Supervisor

  echo ">>>> MacOS - Processer - Supervisor"
  echo

  # >>>> Supervisor - Install required packages

  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(brew list | grep -i "supervisor" | awk "/^supervisor$/")
  if [ "${SUPERVISOR_STATUS}" != "supervisor" ]; then
    brew install supervisor
    echo

    if [ ! -d /opt/homebrew/etc/supervisor.d ]; then
      mkdir -p /opt/homebrew/etc/supervisor.d
    fi
  fi

  if [ -f ${PROJECT_PATH}/scripts/deploy/dev/macos/device/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.ini ]; then
    cp -fv ${PROJECT_PATH}/scripts/deploy/dev/macos/device/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.ini /opt/homebrew/etc/supervisor.d/messenger-worker.ini
    echo
  fi

  # >>>> Supervisor - Start process
  if [ "${ENVIRONMENT_NAME}" == "prod" ]; then
    supervisorctl -c /opt/homebrew/etc/supervisord.conf reread
    echo

    supervisorctl update
    echo

    supervisorctl start messenger-consume:*
    echo

    supervisorctl status
    echo
  fi

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Supervisor

  echo ">>>> Windows - Processer - Supervisor"
  echo

else
  echo "Please check Operating System"
  setExit
fi
