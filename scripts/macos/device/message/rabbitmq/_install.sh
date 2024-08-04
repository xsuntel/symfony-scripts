#!/bin/bash
# ======================================================================================================================
# Scripts - Windows - Desktop - RabbitMQ - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # RabbitMQ - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> RabbitMQ
  echo ">>>> RabbitMQ"
  echo

  local RABBITMQ_PKG
  RABBITMQ_PKG=$(brew list | grep rabbitmq-c)
  if [ "${RABBITMQ_PKG}" ]; then
    brew list | grep rabbitmq-c
  else
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    brew install rabbitmq-c
    brew services info rabbitmq-c
  fi
  echo

  local PECL_STATUS
  PECL_STATUS=$(pecl list | awk '/amqp/ {print $0}' | cut -c 1-6)
  if [ ${PECL_STATUS} ]; then
    pecl list | grep -i amqp
  else
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    sudo pecl install amqp
  fi
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # RabbitMQ - Update the configuration
  # --------------------------------------------------------------------------------------------------------------------

fi
