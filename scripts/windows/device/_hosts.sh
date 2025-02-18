#!/bin/bash
# ======================================================================================================================
# Scripts - Windows - Hosts
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Windows" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # Hosts
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> Hosts"
  echo

  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local PROJECT_HOST_NAME
    PROJECT_HOST_NAME=$(grep -i "symfony.local" /windows/system32/drivers/etc/hosts | awk '{print $2}' | head -n 1)
    if [ ! "${PROJECT_HOST_NAME}" ]; then
      Add-Content -Value "127.0.0.1 symfony.local" -Path /windows/system32/drivers/etc/hosts
      Add-Content -Value "127.0.0.1 api.symfony.local" -Path /windows/system32/drivers/etc/hosts
      Add-Content -Value "127.0.0.1 cdn.symfony.local" -Path /windows/system32/drivers/etc/hosts
      Add-Content -Value "127.0.0.1 www.symfony.local" -Path /windows/system32/drivers/etc/hosts

      sudo grep -v '#' /windows/system32/drivers/etc/hosts
      echo
    fi

  fi

else
  echo "Please check Operating System"
  setExit
fi