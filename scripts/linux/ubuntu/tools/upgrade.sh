#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Upgrade
# ======================================================================================================================
cd /tmp || exit

# ----------------------------------------------------------------------------------------------------------------------
# Ubuntu
# ----------------------------------------------------------------------------------------------------------------------
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # >>>> Upgrade Ubuntu
  local UBUNTU_MAJOR_RELEASE
  UBUNTU_MAJOR_RELEASE=$(cat /etc/lsb-release | grep -i 'DISTRIB_RELEASE' | cut -d "=" -f2 | cut -c 1-2)

  local UBUNTU_UPDATE_MANAGER_PROMPT
  UBUNTU_UPDATE_MANAGER_PROMPT=$(cat /etc/update-manager/release-upgrades | grep -v '#' | grep -i 'Prompt' | cut -d "=" -f2)

  if [ "${UBUNTU_MAJOR_RELEASE}" -le "22" ]; then
    if [ "${UBUNTU_UPDATE_MANAGER_PROMPT}" == "lts" ]; then
        sudo sed -i 's/lts/normal/g' /etc/update-manager/release-upgrades

        echo "You should reboot this VM"
        exit
    else
      sudo apt update -y
      sudo apt upgrade -y
      sudo do-release-upgrade -m server
      echo
      echo "You should reboot this VM"
    fi
  fi
  echo

else
  echo "Please check Operating System"
  setExit
fi