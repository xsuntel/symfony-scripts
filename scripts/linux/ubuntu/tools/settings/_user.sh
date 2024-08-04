#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - User - Permission
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  echo ">>>> Linux - User"
  echo

  echo "- User : ${USER}"
  echo

  # >>>> Remove some packages
  local delUserList="lp sync games uucp news"
  for userItem in ${delUserList}; do
    local USER_LIST
    USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
    if [ "${USER_LIST}" == ${userItem} ]; then
      sudo userdel ${userItem}
    fi
  done

  # >>>> Update a user permission
  if [ ! -f /etc/sudoers.d/$USER ]; then
    sudo echo "${USER} ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
  else
    sudo cat /etc/sudoers.d/$USER
  fi
fi