#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Platform
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux - Ubuntu
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Release
  echo ">>>> Linux - Release"
  echo

  if [ -f /etc/lsb-release ]; then

    local UBUNTU_MAJOR_RELEASE
    UBUNTU_MAJOR_RELEASE=$(cat /etc/lsb-release | grep -i 'DISTRIB_RELEASE' | cut -d "=" -f2 | cut -c 1-2)

    local UBUNTU_UPDATE_MANAGER_PROMPT
    UBUNTU_UPDATE_MANAGER_PROMPT=$(cat /etc/update-manager/release-upgrades | grep -v '#' | grep -i 'Prompt' | cut -d "=" -f2)

    cat /etc/lsb-release
    echo
  fi

  # >>>> TimeZone
  echo ">>>> Linux - TimeZone"
  echo

  local TIMDATECTL_STATUS
  TIMDATECTL_STATUS=$(systemctl is-active systemd-timesyncd)
  if [ "${TIMDATECTL_STATUS}" == "inactive" ]; then
    if [ -f /usr/share/zoneinfo/${PLATFORM_TIMEZONE} ]; then
      sudo ln -snf /usr/share/zoneinfo/${PLATFORM_TIMEZONE} /etc/localtime
    fi
    sudo ls -l /etc/localtime

    sudo timedatectl set-ntp true

    sudo systemctl start systemd-timesyncd

    sudo systemctl status systemd-timesyncd --no-pager
    sudo systemctl enable systemd-timesyncd
    echo
  else
    timedatectl
    echo
  fi

  # >>>> User
  echo ">>>> Linux - User : ${USER}"
  echo

  TARGET_GROUP="www-data"
  CURRENT_USER=$USER

  if id -nG "$CURRENT_USER" | grep -qw "$TARGET_GROUP"; then
    echo "Group : [$TARGET_GROUP] "
  else
    sudo usermod -aG "$TARGET_GROUP" "$CURRENT_USER"
    if [ $? -eq 0 ]; then
        echo "Run  : 'newgrp $TARGET_GROUP'"
    else
        echo "Error: Please check permission"
        exit 1
    fi
  fi
  echo

  local delUserList="sync games uucp news tcpdump mail proxy irc speech-dispatcher"
  for userItem in ${delUserList}; do
    local USER_LIST
    USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
    if [ "${USER_LIST}" == ${userItem} ]; then
      sudo userdel ${userItem}
    fi
  done

  # >>>> Packages
  echo ">>>> Linux - Packages"
  echo

  local addPackageList="curl git wget unzip net-tools"
  for pkgItem in ${addPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
      sudo apt install -y ${pkgItem}
      echo
    fi
  done

  # >>>> Process
  echo ">>>> Linux - Process - Supervisor"
  echo

  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(dpkg -l | grep -i "supervisor" | awk '{print $2}' | cut -d ':' -f1 | awk "/^supervisor$/")
  if [ "${SUPERVISOR_STATUS}" != "supervisor" ]; then
    sudo apt-get install -y supervisor
    echo
  fi

  if [ ! -f /etc/supervisor/conf.d/messenger-worker.conf ]; then
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/tools/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.conf ]; then
      sudo cp -fv ${PROJECT_PATH}/scripts/deploy/dev/linux/ubuntu/tools/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.conf /etc/supervisor/conf.d/messenger-worker.conf
      echo
    fi
  fi

  supervisorctl stop messenger-consume:*
  echo

  supervisorctl status
  echo

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Release
  echo ">>>> MacOS - Release"
  sw_vers
  echo

  # >>>> Rosetta - M1/M2 Chips                                                  https://support.apple.com/en-us/HT211861
  if [ "${PROCESSOR_TYPE}" == "arm64" ]; then
    local ROSETTA_STATUS
    ROSETTA_STATUS=$(/usr/bin/pgrep oahd > /dev/null 2>&1)
    if [ ! ${ROSETTA_STATUS} ]; then
      echo "Rosetta has been already installed"
      echo
    else
      echo ">>>> MacOS - Rosetta"
      softwareupdate --install-rosetta --agree-to-license
      echo

      if [[ $? -eq 0 ]]; then
        echo "This has been successfully installed."
      else
        echo "This installation failed!"
        setExit
      fi
    fi
  fi
  echo

  # >>>> Packages                                                                                        https://brew.sh
  echo ">>>> MacOS - Packages"
  if [ -f /opt/homebrew/bin/brew ]; then
    ls -ltr /opt/homebrew/bin/brew
    echo
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo
  fi

  # >>>> Process
  echo ">>>> MacOS - Process - Supervisor"
  echo

  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(brew list | grep -i "supervisor" | awk "/^supervisor$/")
  if [ "${SUPERVISOR_STATUS}" != "supervisor" ]; then
    brew install supervisor
    echo

    if [ ! -d /opt/homebrew/etc/supervisor.d ]; then
      mkdir -p /opt/homebrew/etc/supervisor.d
    fi
  fi

  if [ ! -f /opt/homebrew/etc/supervisor.d/messenger-worker.ini ]; then
    if [ -f ${PROJECT_PATH}/scripts/deploy/dev/macos/device/tools/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.ini ]; then
      cp -fv ${PROJECT_PATH}/scripts/deploy/dev/macos/device/tools/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.ini /opt/homebrew/etc/supervisor.d/messenger-worker.ini
      echo
    fi
  fi

  supervisorctl stop messenger-consume:*
  echo

  supervisorctl status
  echo

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Release
  echo ">>>> Windows - Release"
  ver
  echo

  # >>>> Package
  echo ">>>> Windows - Packages"
  echo

else
  echo "Please check Operating System"
  setExit
fi
