#!/bin/bash
# ======================================================================================================================
# Scripts - Symfony - Worker
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux - Ubuntu
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Supervisor
  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(dpkg -l | grep -i "supervisor" | awk '{print $2}' | cut -d ':' -f1 | awk "/^supervisor$/")
  if [ "${SUPERVISOR_STATUS}" != "supervisor" ]; then

    sudo apt-get install -y supervisor
    echo
  fi

  # >>>> Supervisor - Configuration
  echo ">>>> Linux - Supervisor - Configuration"
  echo

  sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.conf /etc/supervisor/conf.d/messenger-worker.conf
  echo

  # >>>> Supervisor - Start process
  sudo supervisorctl reread
  echo

  sudo supervisorctl update
  echo

  sudo supervisorctl start messenger-consume:*
  echo

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - MacOS
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Supervisor
  local SUPERVISOR_PKG
    SUPERVISOR_PKG=$(brew list | grep -i "supervisor" | awk "/^supervisor$/")
    if [ "${SUPERVISOR_PKG}" ]; then
      ps -A | grep messenger:consume | grep -v "messenger:consume"
    else
      brew install supervisor
      echo
    fi

  # >>>> Supervisor - Configuration
  echo ">>>> Linux - Supervisor - Configuration"
  echo

  grep -i "files =" /opt/homebrew/etc/supervisord.conf

  if [ ! -d /opt/homebrew/etc/supervisor.d ]; then
    mkdir -p /opt/homebrew/etc/supervisor.d
  fi
  cp -fv ${PROJECT_PATH}/scripts/macos/device/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.ini /opt/homebrew/etc/supervisor.d/messenger-worker.ini
  echo

  # >>>> Supervisor - Start process
  supervisorctl reread
  #supervisorctl -c /opt/homebrew/etc/supervisord.conf reread
  echo

  supervisorctl update
  echo

  supervisorctl start messenger-consume:*
  echo

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows
  # --------------------------------------------------------------------------------------------------------------------

  echo

else
  echo "Please check Operating System"
  setExit
fi

