#!/bin/bash
# ======================================================================================================================
# Scripts - VM - Amazon Linux - Redis - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Redis
  (
    cd /tmp || return

    echo "- Install packages"
    sudo amazon-linux-extras install redis${REDIS_VERSION} -y
    echo

    echo "- Enable this service"
    sudo systemctl enable redis
    echo
  )

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Redis - Update the configuration
  if [ -f /etc/redis/redis.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/amazonlinux/etc/redis/redis_${ENVIRONMENT_NAME}.conf /etc/redis/redis.conf
  fi
  sudo chown redis:root /etc/redis/redis.conf

  sudo systemctl restart redis
fi
