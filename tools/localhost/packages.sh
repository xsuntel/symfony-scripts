#!/bin/bash
# ======================================================================================================================
# Tools - Localhost - Security
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$0")")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
  source ${PROJECT_PATH}/scripts/base/_abstract.sh
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# ----------------------------------------------------------------------------------------------------------------------
# System Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Environment"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_environment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_environment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_environment.sh" && exit
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
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
    fi
    echo

    # >>>> User
    echo ">>>> Linux - User : ${USER}"
    echo

    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      if [ ! -f /etc/sudoers.d/$USER ]; then
        sudo touch /etc/sudoers.d/$USER
        sudo echo "${USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/$USER > /dev/null
      fi
    else
      if [ -f /etc/sudoers.d/$USER ]; then
        sudo rm -f /etc/sudoers.d/$USER
      fi
    fi
    echo

    # >>>> Packages
    echo ">>>> Linux - Packages"
    echo

    # >>>> Packages Remove related network packages
    local delPackageList="ModemManager cups cups-browsed putty putty-tools nmap"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
        sudo apt purge -y ${pkgItem}
        echo
      fi
    done

    # >>>> Packages Remove default applications
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
        sudo apt remove -y --purge ubuntu-advantage-pro
        echo
      fi
    done

    # >>>> Services
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
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

      # >>>> Packages Remove related network packages
      local delPackageList="openssh-server"
      for pkgItem in ${delPackageList}; do
        local APT_PKG_INFO
        APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
        if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
          sudo apt purge -y ${pkgItem}
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
    fi

    # >>>> Packages Files
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
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - MacOS
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Operating System"
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # Software Bundles
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Software Bundles"
    echo

  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Operating System"
    echo

    # ------------------------------------------------------------------------------------------------------------------
    # Software Bundles
    # ------------------------------------------------------------------------------------------------------------------
    echo ">>>> Software Bundles"
    echo

  else
    echo "Please check Operating System"
    setExit
  fi
  echo
}

# ======================================================================================================================
# START
# ======================================================================================================================

# >>>> Start
setStart

# ----------------------------------------------------------------------------------------------------------------------
# System Architecture
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Environment
setEnvironment

# ----------------------------------------------------------------------------------------------------------------------
# VM - Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ======================================================================================================================
# END
# ======================================================================================================================

# >>>> End
setEnd
