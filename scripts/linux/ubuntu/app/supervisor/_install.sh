#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Supervisor - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # Supervisor - Install the packages
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Supervisor
  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(dpkg -l | grep -i "supervisor" | awk '{print $2}' | cut -d ':' -f1 | awk "/^supervisor$/")
  if [ "${SUPERVISOR_STATUS}" != "supervisor" ]; then

    sudo apt-get install -y supervisor
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Supervisor - Update the configuration
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Supervisor
  echo ">>>> Linux - Supervisor - Configuration"
  echo

  sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.conf /etc/supervisor/conf.d/messenger-worker.conf
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Supervisor - Check the configuration
  # --------------------------------------------------------------------------------------------------------------------

  sudo supervisorctl reread
  echo

  sudo supervisorctl update
  echo

  sudo supervisorctl start messenger-consume:*

fi
