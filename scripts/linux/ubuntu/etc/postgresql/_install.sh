#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - PostgreSQL - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # PostgreSQL - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

    # >>>> PostgreSQL
    echo ">>>> PostgreSQL"
    echo

    local POSTGRESQL_STATUS
    POSTGRESQL_STATUS=$(systemctl is-active postgresql)
    if [ "${POSTGRESQL_STATUS}" == "enabled" ]; then

      sudo systemctl is-active postgresql
      echo

    elif [ "${POSTGRESQL_STATUS}" == "inactive" ]; then

      sudo systemctl start postgresql
      echo

    else
      (
        cd /tmp || return

        echo "- Install packages"
        sudo apt-get install -y postgresql
        echo

        echo "- Enable this service"
        sudo systemctl enable postgresql
        echo
      )
    fi

  else
    echo "Prod Environment"
  fi
fi
