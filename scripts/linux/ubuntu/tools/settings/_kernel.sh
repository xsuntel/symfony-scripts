#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Kernel
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  echo ">>>> Linux - Kernel"
  echo

  echo "- PLATFORM Kernel : $(uname -r)"
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

fi