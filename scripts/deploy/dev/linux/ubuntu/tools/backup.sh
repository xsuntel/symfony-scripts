#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Backup
# ======================================================================================================================
# >>>> Platform
PLATFORM_TYPE=$(uname -s)

# >>>> Project
PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")")
PROJECT_NAME=$(basename "$(realpath ${PROJECT_PATH})")

if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Platform - Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    # >>>> Backup
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      set $(date)

      file_name="backup-$1$2$3tar.xz"

      tar cfj /home/$USER/ /home
    fi

else
  echo "Please check Operating System"
  setExit
fi
