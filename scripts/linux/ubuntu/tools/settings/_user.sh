#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - User - Permission
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  echo "- User : ${USER}"
  echo

  # >>>> Update a user permission
  if [ ! -f /etc/sudoers.d/$USER ]; then
    sudo echo "${USER} ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
  else
    sudo cat /etc/sudoers.d/$USER
  fi
fi