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

  sudo ls -l /etc/localtime
  if [ -f /usr/share/zoneinfo/${PLATFORM_TIMEZONE} ]; then
    sudo ln -snf /usr/share/zoneinfo/${PLATFORM_TIMEZONE} /etc/localtime
    echo
  fi
  echo

  # >>>> User
  echo ">>>> Linux - User : ${USER}"
  echo

  local delUserList="lp sync games uucp news tcpdump mail proxy irc"
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

  # >>>> Install required packages
  local addPackageList="curl git wget unzip net-tools"
  for pkgItem in ${addPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
      sudo apt install -y ${pkgItem}
      echo
    fi
  done

  # >>>> Install required packages : Supervisor
  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(dpkg -l | grep -i "supervisor" | awk '{print $2}' | cut -d ':' -f1 | awk "/^supervisor$/")
  if [ "${SUPERVISOR_STATUS}" != "supervisor" ]; then
    sudo apt-get install -y supervisor
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

    sudo supervisorctl status
    echo
  fi

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

  # >>>> Homebrew                                                                                        https://brew.sh
  echo ">>>> MacOS - Homebrew"
  if [ -f /opt/homebrew/bin/brew ]; then
    ls -ltr /opt/homebrew/bin/brew
    echo
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo
  fi

  # >>>> Supervisor
  echo ">>>> MacOS - Supervisor"
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

  if [ -f ${PROJECT_PATH}/scripts/macos/device/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.ini ]; then
    cp -fv ${PROJECT_PATH}/scripts/macos/device/app/supervisor/conf.d/messenger-worker_${ENVIRONMENT_NAME}.ini /opt/homebrew/etc/supervisor.d/messenger-worker.ini
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
  # >>>> Release
  echo ">>>> Windows - Release"
  ver
  echo

else
  echo "Please check Operating System"
  setExit
fi