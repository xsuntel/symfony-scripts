#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - Ubuntu
# ======================================================================================================================

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  echo ">>>> Operating System"
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
  local POSTGRESQL_STATUS
  POSTGRESQL_STATUS=$(systemctl is-active postgresql)
  if [ "${POSTGRESQL_STATUS}" == "inactive" ]; then
    sudo systemctl start postgresql
    sudo systemctl status postgresql --no-pager
    echo
  fi
  echo "PostgreSQL : ${POSTGRESQL_STATUS}"
  echo

  # >>>> Message
  local RABBITMQ_STATUS
  RABBITMQ_STATUS=$(systemctl is-active rabbitmq-server)
  if [ "${RABBITMQ_STATUS}" == "inactive" ]; then
    sudo systemctl start rabbitmq-server
    sudo systemctl status rabbitmq-server --no-pager
    echo
  fi
  echo "RabbitMQ   : ${RABBITMQ_STATUS}"
  echo

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