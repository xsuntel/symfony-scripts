#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Packages
# ======================================================================================================================
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

    # >>>> Packages
    echo ">>>> Linux - Packages"
    echo

    # >>>> Packages - Remove default applications
    local delPackageList="cups cups-browsed gnome-mahjongg gnome-sudoku aisleriot"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
        sudo apt remove -y ${pkgItem}
        echo
      fi
    done

    # >>>> Packages - Disable gnome-shell extensions            https://manpages.ubuntu.com/manpages/focal/en/man1/gsettings.1.html
    local delPackageList="evolution evolution-common evolution-plugins evolution-data-server"
    for pkgItem in ${delPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" == ${pkgItem} ]; then
        sudo apt purge -y ${pkgItem}
        echo
      fi
    done

    if [ -d ~/.local/share/gnome-shell/extensions ]; then
      for ext in $(/usr/bin/ls ~/.local/share/gnome-shell/extensions); do
        gnome-shell-extension-tool -d $ext;
      done
    fi
    gsettings set org.gnome.shell disable-user-extensions true
    echo

    service --status-all | grep '\[ + \]'
    echo

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
fi
