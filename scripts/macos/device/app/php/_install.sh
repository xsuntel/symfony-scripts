#!/bin/bash
# ======================================================================================================================
# Scripts - MacOS - Desktop - PHP - Install
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Darwin" ]; then

  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Install the packages
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PHP
  echo ">>>> PHP"
  echo

  local PHP_PKG
  PHP_PKG=$(brew list | grep php)
  if [ "${PHP_PKG}" ]; then
    local CURRENT_PHP_VERSION
    CURRENT_PHP_VERSION=$(php --version | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
  else
    brew install php@${PHP_VERSION}
    echo
  fi

  echo
  echo "extension-dir : $(php-config --extension-dir)"
  echo

  # >>>> PHP - Extension
  local PHP_XDEBUG
  PHP_XDEBUG=$(pecl list | awk '/xdebug/ {print $0}' | cut -c 1-6)
  if [ ${PHP_XDEBUG} ]; then
    pecl list | grep -i xdebug
  else
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    pecl install xdebug
  fi
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Update the configuration
  # --------------------------------------------------------------------------------------------------------------------
  if [ -f ${PROJECT_PATH}/scripts/macos/device/etc/php/${PHP_VERSION}/php.ini ]; then
    echo ">>>> PHP - Configuration"
    cp -fv ${PROJECT_PATH}/scripts/macos/device/etc/php/${PHP_VERSION}/php.ini /opt/homebrew/etc/php/${PHP_VERSION}/
    echo
  fi

  # --------------------------------------------------------------------------------------------------------------------
  # PHP - Composer
  # --------------------------------------------------------------------------------------------------------------------
  local PHP_COMPOSER
  PHP_COMPOSER=$(brew list | grep composer)
  if [ "${PHP_COMPOSER}" ]; then
    echo "Composer  : $(composer --version)"
  else
    brew install composer
  fi
  echo

  php --version
  echo

  php --ini
  echo

  # --------------------------------------------------------------------------------------------------------------------
  # Symfony - Front-End
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Node
  local NODE_PKG
  NODE_PKG=$(brew list | grep node@${NODE_VERSION})
  if [ ! -f /opt/homebrew/opt/node@${NODE_VERSION}/bin/node ]; then
    (
      cd /tmp || return

      brew install node@${NODE_VERSION}
      echo

      brew unlink node@${NODE_VERSION} && brew link node@${NODE_VERSION}
      echo

      brew install yarn
      echo

      brew unlink yarn && brew link yarn
      echo
    )
  fi

fi