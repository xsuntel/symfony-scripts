#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu - Redis - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # Redis - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Redis
  echo ">>>> Redis"
  echo

  local REDIS_STATUS
  REDIS_STATUS=$(dpkg -l | grep -i "redis-server" | awk '{print $2}' | cut -d ':' -f1 | awk "/^redis-server$/")
  if [ "${REDIS_STATUS}" != "redis-server" ]; then
    sudo apt install -y redis-server
    echo

    sudo systemctl enable redis-server
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Redis - Update the configuration                                            https://redis.io/docs/management/config/
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Redis - Configuration
  if [ -f /etc/redis/redis.conf ]; then
    sudo cp -fv ${PROJECT_PATH}/scripts/linux/ubuntu/cache/redis/redis_${ENVIRONMENT_NAME}.conf /etc/redis/redis.conf
    sudo chown redis:redis /etc/redis/redis.conf
  fi

  # >>>> Redis - Remove log files
  if [ -f /var/log/redis/redis-server.log ]; then
    sudo cat /dev/null > /var/log/redis/redis-server.log
  fi

  # >>>> Redis - Delete logs files
  if [ -f /var/log/redis/redis-server.log.1 ]; then
    sudo rm -fv /var/log/redis/redis-server.log.*
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # Redis - Check status
  # --------------------------------------------------------------------------------------------------------------------

  local REDIS_STATUS
  REDIS_STATUS=$(systemctl is-active redis-server)
  if [ "${REDIS_STATUS}" == "active" ]; then
    sudo systemctl restart redis-server
    echo
  else
    sudo systemctl start redis-server
    echo
  fi

  redis-server -v
fi
