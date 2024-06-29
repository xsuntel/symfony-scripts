#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Hosts
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    echo ">>>> Linux - Hosts"
    echo

    local PROJECT_HOST_NAME
    PROJECT_HOST_NAME=$(grep -i "symfony.local" /etc/hosts | awk '{print $2}' | head -n 1)
    if [ ! "${PROJECT_HOST_NAME}" ]; then
      echo $'\n127.0.0.1 symfony.local' | sudo tee -a /etc/hosts
      echo $'\n127.0.0.1 api.symfony.local' | sudo tee -a /etc/hosts
      echo $'\n127.0.0.1 cdn.symfony.local' | sudo tee -a /etc/hosts
      echo $'\n127.0.0.1 www.symfony.local' | sudo tee -a /etc/hosts

      echo ">>>> Hosts"
      sudo grep -v '#' /etc/hosts
      echo
    fi
  fi
fi