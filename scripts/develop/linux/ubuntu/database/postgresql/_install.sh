#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - PostgreSQL - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # PostgreSQL - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PostgreSQL
  echo ">>>> PostgreSQL"
  echo

  local POSTGRESQL_STATUS
  POSTGRESQL_STATUS=$(dpkg -l | grep -i "postgresql" | awk '{print $2}' | cut -d ':' -f1 | awk "/^postgresql$/")
  if [ "${POSTGRESQL_STATUS}" != "postgresql" ]; then
    sudo apt install -y postgresql
    echo

    sudo systemctl enable postgresql
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # PostgreSQL - Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> PostgreSQL - Configuration"
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # PostgreSQL - Check status
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> PostgreSQL - Status"
  echo

  local POSTGRESQL_STATUS
  POSTGRESQL_STATUS=$(systemctl is-active postgresql)
  if [ "${POSTGRESQL_STATUS}" == "active" ]; then
    sudo systemctl restart postgresql
    echo
  else
    sudo systemctl start postgresql
    echo
  fi

  psql --version
fi
