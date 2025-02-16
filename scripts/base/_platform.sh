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

  # >>>> Kernel
  echo ">>>> Linux - Kernel"
  echo

  echo "- PLATFORM Kernel : $(uname -r)"
  echo

  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    sudo systemctl daemon-reload
    echo

    # >>>> Check kernel list
    local NOW_KERNEL_VERSION=$(uname -r | cut -d '-' -f 1,2)
    local DEL_KERNEL_VERSION=$(dpkg --list | grep linux-image- |grep -v linux-image-${OLD_KERNEL_VERSION} | grep -v linux-image-generic-hwe |awk  '{print $2}')

    if [ ${DEL_KERNEL_VERSION} ]; then
      dpkg --list | grep linux-image
      echo

      echo "sudo apt-get purge -y ${DEL_KERNEL_VERSION} -f"
      echo
    fi
    sudo apt update -y
    echo
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

  local delUserList="lp sync games uucp news tcpdump"
  for userItem in ${delUserList}; do
    local USER_LIST
    USER_LIST=$(cat /etc/passwd | awk -F: '{print $1}' | grep -i "${userItem}")
    if [ "${USER_LIST}" == ${userItem} ]; then
      sudo userdel ${userItem}
    fi
  done

  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    if [ ! -f /etc/sudoers.d/$USER ]; then
      sudo touch /etc/sudoers.d/$USER
      sudo echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
    fi
  fi

  # >>>> Supervisor
  echo ">>>> Linux - Supervisor"
  echo

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

  # >>>> Package
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

  # >>>> Remove related network packages
  local delPackageList="cups cups-browsed openssh-server putty putty-tools nmap"
  for pkgItem in ${delPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
      sudo apt purge -y ${pkgItem}
      echo
    fi
  done

  # >>>> Remove default applications
  local delPackageList="libreoffice thunderbird remmina gnome-mahjongg gnome-sudoku aisleriot"
  for pkgItem in ${delPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
      sudo apt remove -y ${pkgItem}
      echo
    fi
  done

  local delPackageList="evolution evolution-common evolution-plugins evolution-data-server"
  for pkgItem in ${delPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
      sudo apt purge -y ${pkgItem}
      echo
    fi
  done

  local delPackageList="ubuntu-advantage-pro"
  for pkgItem in ${delPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
      sudo apt remove -y --purge ubuntu-advantage*
      echo
    fi
  done

  # >>>> Services
  echo ">>>> Linux - Services"
  echo

  # >>>> Firewall - SSH - Ubuntu Desktop
  local SSHD_STATUS
  SSHD_STATUS=$(systemctl is-active sshd)
  if [ "${SSHD_STATUS}" == "active" ]; then
    sudo systemctl stop sshd
    sudo systemctl disable sshd
  fi
  echo

  # >>>> Disable default services
  local delPackageList="ModemManager"
  for pkgItem in ${delPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
      sudo systemctl disable --now ${pkgItem}
      echo
    fi
  done

  # >>>> Disable gnome-shell extensions          https://manpages.ubuntu.com/manpages/focal/en/man1/gsettings.1.html
  if [ -d ~/.local/share/gnome-shell/extensions ]; then
    for ext in $(/usr/bin/ls ~/.local/share/gnome-shell/extensions); do
      gnome-shell-extension-tool -d $ext;
    done
  fi
  gsettings set org.gnome.shell disable-user-extensions true
  echo

  service --status-all | grep '\[ + \]'
  echo

  # >>>> Package
  echo ">>>> Linux - Files"
  echo

  if [ -d /tmp ]; then
    sudo rm -rf /tmp/*
  fi

  if [ -d /home/${LOGNAME}/.cache ]; then
    sudo rm -rf /home/${LOGNAME}/.cache/*
  fi

  sudo apt autoremove -y
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