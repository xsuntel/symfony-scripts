#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - Linux - Ubuntu - Booting - kernel
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # kernel
      # ----------------------------------------------------------------------------------------------------------------

      echo ">>>> Linux - booting - kernel : $(uname -r)"
      echo

      sudo systemctl daemon-reload
      echo

      local NOW_KERNEL_VERSION
      local DEL_KERNEL_VERSION
      NOW_KERNEL_VERSION=$(uname -r | cut -d '-' -f 1,2)
      DEL_KERNEL_VERSION=$(dpkg --list | grep linux-image- |grep -v "linux-image-${OLD_KERNEL_VERSION}" | grep -v linux-image-generic-hwe |awk  '{print $2}')

      if [ "${DEL_KERNEL_VERSION}" ]; then
        dpkg --list | grep linux-image
        echo

        echo "sudo apt-get purge -y ${DEL_KERNEL_VERSION} -f"
        echo
      fi

    fi
fi
