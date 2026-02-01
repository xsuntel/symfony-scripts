#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - Linux - Ubuntu - Network
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

      # ----------------------------------------------------------------------------------------------------------------
      # Kernel
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Kernel
      echo ">>>> Linux - Kernel : $(uname -r)"
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

      # >>>> Kernel - Network - ipv4
      sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1
      echo

      # ----------------------------------------------------------------------------------------------------------------
      # Hosts
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Hosts
      local PROJECT_HOST_NAME
      PROJECT_HOST_NAME=$(sudo grep -i "localhost" /etc/hosts | awk '{print $2}' | head -n 1)
      if [ ! "${PROJECT_HOST_NAME}" ]; then
        echo ">>>> Linux - Hosts"
        echo

        echo $'\n127.0.0.1 localhost' | sudo tee -a /etc/hosts
        echo

        sudo grep -v '#' /etc/hosts
        echo
      fi

      # ----------------------------------------------------------------------------------------------------------------
      # Network
      # ----------------------------------------------------------------------------------------------------------------

      # >>>> Network
      if [ -f /etc/rc.local ]; then
        sudo cp -fv "${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/utility/base/network/etc/rc.local" /etc/rc.local
        sudo systemctl status rc-local.service  --no-pager
        echo
      else

        sudo cp -fv "${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/utility/base/network/etc/rc.local" /etc/rc.local
        sudo chmod +x /etc/rc.local
        echo

        sudo systemctl enable rc-local.service
        echo

        sudo systemctl start rc-local.service
        echo

        # >>>> Network - ufw
        if [ -f "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/utility/base/network/_ufw.sh ]; then
          source "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/utility/base/network/_ufw.sh
        else
          echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/utility/base/network/_ufw.sh" && exit
        fi
        echo

        # >>>> Network - ebtables
        if [ -f "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/utility/base/network/_ebtables.sh ]; then
          source "${PROJECT_PATH}"/scripts/deploy/dev/linux/ubuntu/utility/base/network/_ebtables.sh
        else
          echo "Please check a file : ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/utility/base/network/_ebtables.sh" && exit
        fi
        echo

      fi
      echo

    fi
fi
