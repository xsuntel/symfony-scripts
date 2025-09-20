#!/bin/bash
# ======================================================================================================================
# Scripts - Windows - Desktop- Hosts
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Windows
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Hosts
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local PROJECT_HOST_NAME
      PROJECT_HOST_NAME=$(grep -i "symfony.local" /windows/system32/drivers/etc/hosts | awk '{print $2}' | head -n 1)
      if [ ! "${PROJECT_HOST_NAME}" ]; then
        Add-Content -Value "127.0.0.1 symfony.local" -Path /windows/system32/drivers/etc/hosts
        Add-Content -Value "127.0.0.1 api.symfony.local" -Path /windows/system32/drivers/etc/hosts
        Add-Content -Value "127.0.0.1 cdn.symfony.local" -Path /windows/system32/drivers/etc/hosts
        Add-Content -Value "127.0.0.1 www.symfony.local" -Path /windows/system32/drivers/etc/hosts
        echo
      fi
    fi

    echo ">>>> Windows - Hosts"
    echo
    grep -v '#' /windows/system32/drivers/etc/hosts
    echo
fi
