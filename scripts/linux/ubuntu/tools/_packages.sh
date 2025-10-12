#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Packages
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------

    # >>>> Packages
    echo ">>>> Linux - Packages"
    echo

    # >>>> Packages - Remove default applications
    local delPackageList="gnome-mahjongg gnome-sudoku aisleriot"
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
fi
