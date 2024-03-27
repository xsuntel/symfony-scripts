#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Redis - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # >>>> Memory for Redis
  sudo sysctl vm.overcommit_memory=1

  # >>>> Remove log files
  if [ -f /var/log/redis/redis-server.log ]; then
    sudo cat /dev/null > /var/log/redis/redis-server.log
  fi
  # --------------------------------------------------------------------------------------------------------------------
  # Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Redis
  local REDIS_STATUS
  REDIS_STATUS=$(dpkg -l | grep -i "redis-server" | awk '{print $2}' | cut -d ':' -f1 | awk "/^redis-server$/")
  if [ "${REDIS_STATUS}" != "redis-server" ]; then
    # >>>> PHP - required packages
    local addPackageList="redis-server"
    for pkgItem in ${addPackageList}; do
      local APT_PKG_INFO
      APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
      if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
        sudo apt install -y ${pkgItem}
        echo
      fi
    done
    echo

    echo "- Enable this service"
    sudo systemctl enable redis-server
  fi
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Update the configuration                                                    https://redis.io/docs/management/config/
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Redis - Configuration
  if [ -f /etc/redis/redis.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/etc/redis/redis_${ENVIRONMENT_NAME}.conf /etc/redis/redis.conf
    sudo chown redis:redis /etc/redis/redis.conf
  fi

  sudo systemctl restart redis

  redis-server -v
fi
