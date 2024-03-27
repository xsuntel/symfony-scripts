#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - CentOS - Redis
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Redis
  (
    cd /tmp || return

    sudo dnf install -y redis --skip-broken

    sudo systemctl enable redis

    sudo systemctl start redis
  )

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Redis - Update the configuration
  if [ -f /etc/redis/redis.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/centos/etc/redis/redis_${ENVIRONMENT_NAME}.conf /etc/redis/redis.conf
  fi
  sudo chown redis:root /etc/redis/redis.conf

  sudo systemctl restart redis
fi