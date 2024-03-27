#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - CentOS - MongoDB - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> MongoDB
  if [ ! -f "/etc/yum.repos.d/mongodb-org-${MONGODB_VERSION}_aarch64.repo" ] && [ ! -f "/etc/yum.repos.d/mongodb-org-${MONGODB_VERSION}_x86_64.repo" ]; then
    local DEVICE_CPU
    DEVICE_CPU=$(uname -p)
    if [ "${DEVICE_CPU}" == "aarch64" ]; then
      sudo cp -fv ${PROJECT_PATH}/scripts/centos/server/etc/yum.repos.d/mongodb-org-${MONGODB_VERSION}_aarch64.repo /etc/yum.repos.d/
    else
      sudo cp -fv ${PROJECT_PATH}/scripts/centos/server/etc/yum.repos.d/mongodb-org-${MONGODB_VERSION}_x86_64.repo /etc/yum.repos.d/
    fi
    sudo chown root:root /etc/yum.repos.d/mongodb-org-*.repo
    sudo chmod 744 /etc/yum.repos.d/mongodb-org-*.repo

    # >>>> Update packages
    sudo dnf clean dbcache
    sudo dnf check-update

    sudo dnf install -y mongodb-org --skip-broken
    echo

    sudo systemctl enable mongod

    sudo systemctl start mongod

  else
    echo "There is a file : /etc/yum.repos.d/mongodb-org-${MONGODB_VERSION}_${DEVICE_CPU}.repo"
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------

fi
