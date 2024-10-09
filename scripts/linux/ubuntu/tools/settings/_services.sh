#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Services
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  echo ">>>> Linux - Services"
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Disable default services
  # --------------------------------------------------------------------------------------------------------------------
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

  # --------------------------------------------------------------------------------------------------------------------
  # Disable gnome services
  # --------------------------------------------------------------------------------------------------------------------
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

  # --------------------------------------------------------------------------------------------------------------------
  # Disable Ubuntu Pro
  # --------------------------------------------------------------------------------------------------------------------
  sudo apt remove -y --purge ubuntu-advantage*

  sudo apt autoremove -y
  echo
fi
