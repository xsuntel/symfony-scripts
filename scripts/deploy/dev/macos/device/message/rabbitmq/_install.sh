#!/bin/bash
# ======================================================================================================================
# Scripts - Windows - Desktop - RabbitMQ - Install                        https://www.rabbitmq.com/docs/install-homebrew
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # RabbitMQ - Install the related packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> RabbitMQ
  echo ">>>> RabbitMQ"
  echo

  local RABBITMQ_LIB
  RABBITMQ_LIB=$(brew list | grep 'rabbitmq-c$')
  if [ "${RABBITMQ_LIB}" ]; then
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
    echo "-------------------------------------------------------------------------------------------------------------"
    echo ls -ltr /opt/homebrew/Cellar/rabbitmq-c/
    echo
    echo "Please check the related version"
    echo "Set the path to librabbitmq install prefix [autodetect] : /opt/homebrew/Cellar/rabbitmq-c/0.XX.0"
    echo "-------------------------------------------------------------------------------------------------------------"
    echo

    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    pecl install amqp
  fi
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # RabbitMQ - Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  echo ">>>> RabbitMQ - Configuration"
  echo

  local RABBITMQ_PKG
  RABBITMQ_PKG=$(brew list | grep 'rabbitmq$')
  if [ "${RABBITMQ_PKG}" ]; then
    brew services info rabbitmq
  else
    brew install rabbitmq
  fi
  echo

  # >>>> Process : Background

  # starts a local RabbitMQ node
  brew services start rabbitmq

  # highly recommended: enable all feature flags on the running node
  /opt/homebrew/sbin/rabbitmqctl enable_feature_flag all
  echo

fi
