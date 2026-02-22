#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - Linux - Ubuntu - Booting - systemd - service
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # systemd - service
      # ----------------------------------------------------------------------------------------------------------------

      echo ">>>> Linux - Booting - systemd - service"
      echo

      if [ -f /etc/rc.local ]; then
        sudo cp -fv "${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/booting/etc/rc.local" /etc/rc.local
        sudo systemctl status rc-local.service  --no-pager
        echo
      else

        sudo cp -fv "${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/booting/etc/rc.local" /etc/rc.local
        sudo chmod +x /etc/rc.local
        echo

        sudo systemctl enable rc-local.service
        echo

        sudo systemctl start rc-local.service
        echo

      fi
      echo

    fi
fi
