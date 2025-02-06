#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # Hardware
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> Hardware"
  echo

  # >>>> Check status
  echo "CPU"
  echo
  top -b -n 1 | head -n 5
  echo

  echo "Memory"
  echo
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    sudo sysctl -w vm.min_free_kbytes=2000000                                                         # default :16384
    sudo sysctl -w vm.vfs_cache_pressure=10000                                                        # default : 100
    sudo sysctl -w vm.drop_caches=2
    sudo sysctl -w vm.swappiness=0
    echo

    echo 2 > sudo /proc/sys/vm/drop_caches
    echo 0 > sudo /proc/sys/vm/swappiness
    sudo swapoff -a && sudo swapon -a
  fi
  free -m
  echo

  sudo slabtop -o | grep dentry
  echo

  cat /proc/meminfo | grep -i anon
  echo

  echo "SSD"
  echo
  df -h
  echo

  echo "Network"
  echo
  # >>>> Network - ipv6
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
  sudo cat /proc/sys/net/ipv6/conf/all/disable_ipv6
  echo

  netstat -napo | grep -i time_wait
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Operating System
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> Operating System"
  echo

  # >>>> TimeZone
  echo "TimeZone"
  timedatectl
  echo

  # >>>> Firewall
  local UFW_STATUS
  UFW_STATUS=$(systemctl is-active ufw)
  if [ "${UFW_STATUS}" == "inactive" ]; then
    sudo systemctl start ufw
    sudo systemctl status ufw --no-pager
    echo
  fi
  echo "Firewall   : ${UFW_STATUS}"
  echo

  # >>>> Cron
  local CRON_STATUS
  CRON_STATUS=$(systemctl is-active cron)
  if [ "${CRON_STATUS}" == "inactive" ]; then
    sudo systemctl start cron
    sudo systemctl status cron --no-pager
    echo
  fi
  echo "Cron       : ${CRON_STATUS}"
  echo

  # >>>> Supervisor
  local SUPERVISOR_STATUS
  SUPERVISOR_STATUS=$(systemctl is-active supervisor)
  if [ "${SUPERVISOR_STATUS}" == "inactive" ]; then
    sudo systemctl start supervisor
    sudo systemctl status supervisor --no-pager
    echo
  fi
  echo "Supervisor : ${SUPERVISOR_STATUS}"
  echo

  # >>>> Rsyslog
  local RSYSLOG_STATUS
  RSYSLOG_STATUS=$(systemctl is-active rsyslog)
  if [ "${RSYSLOG_STATUS}" == "inactive" ]; then
    sudo systemctl start rsyslog
    sudo systemctl status rsyslog --no-pager
    echo
  fi
  echo "Rsyslog    : ${RSYSLOG_STATUS}"
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Software Bundles
  # --------------------------------------------------------------------------------------------------------------------
  echo
  echo ">>>> Software Bundles"
  echo

  # >>>> App
  local PHP_STATUS
  PHP_STATUS=$(systemctl is-active php${PHP_VERSION}-fpm)
  if [ "${PHP_STATUS}" == "inactive" ]; then
    sudo systemctl start php${PHP_VERSION}-fpm
    sudo systemctl status php${PHP_VERSION}-fpm --no-pager
    echo
  fi
  echo "PHP-FPM    : ${PHP_STATUS}"
  echo

  # >>>> Cache
  local REDIS_STATUS
  REDIS_STATUS=$(systemctl is-active redis)
  if [ "${REDIS_STATUS}" == "inactive" ]; then
    sudo systemctl start redis
    sudo systemctl status redis --no-pager
    echo
  fi
  echo "REDIS      : ${REDIS_STATUS}"
  echo

  # >>>> Database
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local POSTGRESQL_STATUS
    POSTGRESQL_STATUS=$(systemctl is-active postgresql)
    if [ "${POSTGRESQL_STATUS}" == "inactive" ]; then
      sudo systemctl start postgresql
      sudo systemctl status postgresql --no-pager
      echo
    fi
    echo "Database    - PostgreSQL : ${POSTGRESQL_STATUS}"
    echo
  fi

  # >>>> Messenger
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    local RABBITMQ_STATUS
    RABBITMQ_STATUS=$(systemctl is-active rabbitmq-server)
    if [ "${RABBITMQ_STATUS}" == "inactive" ]; then
      sudo systemctl start rabbitmq-server
      sudo systemctl status rabbitmq-server --no-pager
      echo
    fi
    echo "Message     - RabbitMQ   : ${RABBITMQ_STATUS}"
    echo
  fi

  # >>>> Server
  local NGINX_STATUS
  NGINX_STATUS=$(systemctl is-active nginx)
  if [ "${NGINX_STATUS}" == "inactive" ]; then
    sudo systemctl start nginx
    sudo systemctl status nginx --no-pager
    echo
  fi
  echo "NGINX      : ${NGINX_STATUS}"
  echo

else
  echo "Please check Operating System"
  setExit
fi