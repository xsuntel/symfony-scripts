#!/bin/bash
# ======================================================================================================================
# Scripts - Platform
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Linux - Ubuntu
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Release
  if [ -f /etc/lsb-release ]; then
    echo ">>>> Release"
    cat /etc/lsb-release
    echo

    sudo apt list --upgradable
    sudo apt update -y
    sudo apt upgrade -y
  fi

  # >>>> Install required packages
  local addPackageList="make acl curl git wget unzip"
  for pkgItem in ${addPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
      sudo apt install -y ${pkgItem}
      echo
    fi
  done

  # >>>> Remove additional packages
  if [ -f /etc/needrestart/needrestart.conf ]; then
    sudo apt purge -y needrestart
  fi
  echo

  # >>>> TimeZone
  sudo ls -l /etc/localtime
  if [ -f /usr/share/zoneinfo/${PLATFORM_TIMEZONE} ]; then
    sudo ln -snf /usr/share/zoneinfo/${PLATFORM_TIMEZONE} /etc/localtime
  fi
  timedatectl
  echo

  # >>>> Rsyslog
  local RSYSLOG_STATUS
  RSYSLOG_STATUS=$(systemctl is-active rsyslog)
  if [ "${RSYSLOG_STATUS}" == "active" ]; then
    echo ${RSYSLOG_STATUS}
  else
    sudo apt-get install -y rsyslog
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/etc/rsyslog.conf /etc/rsyslog.conf
    sudo systemctl restart rsyslog
  fi
  echo

  # >>>> Supervisor
  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(systemctl is-active supervisor)
  if [ "${SUPERVISOR_STATUS}" == "active" ]; then
    # >>>> conf.d/messenger-worker.conf
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/etc/supervisor/conf.d/messenger-worker.conf /etc/supervisor/conf.d/messenger-worker.conf
    echo
    sudo supervisorctl reread
  else
    sudo apt-get install -y supervisor
  fi
  echo

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Release
  echo ">>>> Release"
  sw_vers
  echo

  # >>>> Rosetta - M1/M2 Chips                                                  https://support.apple.com/en-us/HT211861
  if [ "${PROCESSOR_TYPE}" == "arm64" ]; then
    local ROSETTA_STATUS
    ROSETTA_STATUS=$(/usr/bin/pgrep oahd > /dev/null 2>&1)
    if [ ! ${ROSETTA_STATUS} ]; then
      echo "Rosetta has been already installed"
    else
      echo ">>>> Rosetta - Updating"
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

  # >>>> Homebrew                                                                                        https://brew.sh
  if [ ! -f /opt/homebrew/bin/brew ]; then
    echo ">>>> Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo
  fi

  # >>>> Hosts
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local PROJECT_HOST_NAME
    PROJECT_HOST_NAME=$(grep -i "symfony.local" /etc/hosts | awk '{print $2}' | head -n 1)
    if [ ! "${PROJECT_HOST_NAME}" ]; then
      echo $'\n127.0.0.1 symfony.local' | sudo tee -a /etc/hosts
      echo $'\n127.0.0.1 api.symfony.local' | sudo tee -a /etc/hosts

      echo ">>>> Hosts"
      sudo grep -v '#' /etc/hosts
      echo
    fi
  fi

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Windows
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Release
  echo ">>>> Release"
  ver
  echo

  # >>>> Hosts
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local PROJECT_HOST_NAME
    PROJECT_HOST_NAME=$(grep -i "symfony.local" /windows/system32/drivers/etc/hosts | awk '{print $2}' | head -n 1)
    if [ ! "${PROJECT_HOST_NAME}" ]; then
      Add-Content -Value "127.0.0.1 symfony.local" -Path /windows/system32/drivers/etc/hosts
      Add-Content -Value "127.0.0.1 api.symfony.local" -Path /windows/system32/drivers/etc/hosts

      echo ">>>> Hosts"
      sudo grep -v '#' /windows/system32/drivers/etc/hosts
      echo
    fi
  fi

else
  echo "Please check Operating System"
  setExit
fi