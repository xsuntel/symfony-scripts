#!/bin/bash
# ======================================================================================================================
# Scripts - MacOS - Desktop - Redis - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Darwin" ]; then

  # >>>> Redis - Extension
  local PECL_STATUS
  PECL_STATUS=$(pecl list | awk '/redis/ {print $0}' | cut -c 1-6)
  if [ ${PECL_STATUS} ]; then
    pecl list redis
  else
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    pecl install redis
  fi
  echo

  # >>>> Redis
  local REDIS_PKG
  REDIS_PKG=$(brew list | grep redis)
  if [ "${REDIS_PKG}" ]; then
    brew services info redis
  else
    brew install redis
  fi
  echo

  brew services restart redis
  echo

fi