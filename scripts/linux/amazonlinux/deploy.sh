#!/bin/bash
# ======================================================================================================================
# Scripts - Linux - AmazonLinux - Deploy
# ======================================================================================================================

PROJECT_PATH=$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")
cd "${PROJECT_PATH}" || exit

# >>>> Abstract

if [ -f ${PROJECT_PATH}/scripts/base/_abstract.sh ]; then
  source ${PROJECT_PATH}/scripts/base/_abstract.sh
else
  echo "Please check a file : ${PROJECT_PATH}/scripts/base/_abstract.sh" && exit
fi

# >>>> Environment

setEnvironment() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ ENV ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE}"
  echo "---------------------------------------------------------------------------------------------------------------"
  # >>>> Import an environment file
  if [ -f ${PROJECT_PATH}/scripts/base/_environment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_environment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_environment.sh" && exit
  fi
  echo
}

# >>>> Platform

setPlatform() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Platform"
  echo "---------------------------------------------------------------------------------------------------------------"

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    echo "- PLATFORM OS : ${PLATFORM_TYPE}"
    echo

    # >>>> Base packages
    (
      cd /tmp || return

      echo
      sudo sestatus
      echo

      # >>>> Update Packages
      echo "- System"
      sudo yum update -y
      echo

      # >>>> Install epel
      if [ ! -f /etc/yum.repos.d/epel.repo ]; then
        sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
        sudo yum clean metadata
      fi

      # >>>> Install remi packages
      if [ ! -f /etc/yum.repos.d/remi.repo ]; then
        sudo yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
        sudo yum clean metadata
      fi

      # >>>> Install additional packages
      local addPackageList="libevent-devel libxml2-devel yum-cron curl git net-tools wget"
      for pkgName in $addPackageList; do
        local YUM_PKG_INFO
        YUM_PKG_INFO=$(sudo yum info $pkgName | grep "Repo        :" | awk '{print $3}')
        if [ "${YUM_PKG_INFO}" != "installed" ]; then
          sudo yum install -y $pkgName
          echo
        fi
      done
    )

    # >>>> Update TimeZone
    sudo ls -l /etc/localtime
    if [ -f /usr/share/zoneinfo/${PLATFORM_TIMEZONE} ]; then
      sudo ln -snf /usr/share/zoneinfo/${PLATFORM_TIMEZONE} /etc/localtime
    fi
    timedatectl
    echo

    # >>>> Update Crontab
    local CRONTAB_STATUS
    CRONTAB_STATUS=$(sudo systemctl is-active cron)
    if [ "${CRONTAB_STATUS}" == "active" ]; then
      sudo systemctl status cron.service --no-pager
    elif [ "${CRONTAB_STATUS}" == "failed" ]; then
      sudo systemctl start cron.service
    else
      sudo systemctl is-enabled cron.service
    fi
    echo

    # >>>> Check amazon-linux-extra packages - Apache
    local AMAZON_LINUX_EXTRAS_APACHE
    AMAZON_LINUX_EXTRAS_APACHE=$(sudo amazon-linux-extras | grep -i httpd_modules | awk '{print $3}')
    if [ "${AMAZON_LINUX_EXTRAS_APACHE}" == "enabled" ]; then
      sudo amazon-linux-extras disable httpd_modules
      sudo rpm -e httpd --nodeps
    fi

    # >>>> Check amazon-linux-extra packages - Docker
    local ePkglist="docker"
    for pkg in $ePkglist; do
      local AMAZON_LINUX_EXTRAS
      AMAZON_LINUX_EXTRAS=$(sudo amazon-linux-extras | grep -i $pkg | awk '{print $3}')
      if [ "${AMAZON_LINUX_EXTRAS}" == "enabled" ]; then
        sudo amazon-linux-extras disable $pkg
        echo
      fi
    done

    # >>>> Hosts
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
      local PROJECT_HOST_NAME
      PROJECT_HOST_NAME=$(grep -i "xsun.local" /etc/hosts | awk '{print $2}' | head -n 1)
      if [ ! "${PROJECT_HOST_NAME}" ]; then
        echo $'\n127.0.0.1 xsun.local' | sudo tee -a /etc/hosts
        echo $'\n127.0.0.1 api.xsun.local' | sudo tee -a /etc/hosts

        echo ">>>> Hosts"
        sudo grep -v '#' /etc/hosts
        echo
      fi
    fi

  else
    echo "Please check Operating System"
    setExit
  fi
}

# >>>> Project

setProject() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Project"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "- PROJECT NAME : ${PROJECT_NAME}"
  echo

  # >>>> Import a project file
  if [ -f ${PROJECT_PATH}/scripts/base/_project.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_project.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_project.sh" && exit
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App

setPhp() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - App - PHP"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/php/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/php/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/php/_install.sh"
    exit
  fi
  echo

  # >>>> PHP - Symfony - Command Line Interface
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_command.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_command.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_command.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony - Front-End
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_frontend.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_frontend.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_frontend.sh" && exit
  fi
  echo
}

# >>>> Cache

setRedis() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Cache - Redis"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/redis/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/redis/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/redis/_install.sh" && exit
  fi
  echo
}

# >>>> Database

setPostgreSQL() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Database - PostgreSQL"
  echo "---------------------------------------------------------------------------------------------------------------"
}

# >>>> Server

setNginx() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Server - Nginx"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Import an install file
  if [ -f ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/nginx/_install.sh ]; then
    source ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/nginx/_install.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/vm/amazonlinux/etc/nginx/_install.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony - Deployment
  if [ -f ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh ]; then
    source ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh
  else
    echo "Please check a file : ${PROJECT_PATH}/scripts/base/_symfony_deployment.sh" && exit
  fi
  echo

  # >>>> PHP - Symfony - Setting up or Fixing File Permissions - https://symfony.com/doc/current/setup/file_permissions.html
  (
    cd app || return

    HTTPDUSER="$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)"

    sudo setfacl -dR -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var
    sudo setfacl -R -m g:"${HTTPDUSER}":rwX -m u:"$(whoami)":rwX ./var

    sudo usermod -a -G "${HTTPDUSER}" "$(whoami)"
    sudo chown "${HTTPDUSER}":"${HTTPDUSER}" -R ./*
    sudo chmod 777 -R ./var
  )

  # >>>> Delete logs files
  if [ -f /var/log/nginx/www_access.log.1 ]; then
    sudo rm -fv /var/log/nginx/www_access.log.*
    echo
  fi

  # >>>> Delete logs files
  if [ -f /var/log/nginx/www_error.log.1 ]; then
    sudo rm -fv /var/log/nginx/www_error.log.*
    echo
  fi
}

# ----------------------------------------------------------------------------------------------------------------------
# Scripts
# ----------------------------------------------------------------------------------------------------------------------

setCDN() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Tools - AWS : AWSCLI"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # >>>> Python
    (
      cd /tmp || return

      sudo amazon-linux-extras install python${PYTHON_VERSION} -y
    )
    echo

    # >>>> AWS - CLI                 https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html
    if [ -f /usr/local/bin/aws ]; then
      aws --version
      echo
    else
      (
        cd /tmp || return

        if [ "${PLATFORM_NAME}" == "aarch64" ]; then
          sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "${AWSCLI_VERSION}.zip"
        else
          sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${AWSCLI_VERSION}.zip"
        fi
        unzip "${AWSCLI_VERSION}.zip"
        sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

        if [ -d /tmp/aws ]; then
          sudo rm -rfv /tmp/aws
        fi

        if [ -f /tmp/"${AWSCLI_VERSION}.zip" ]; then
          sudo rm -fv /tmp/"${AWSCLI_VERSION}.zip"
        fi
      )
    fi
  fi

  # >>>> AWS - Import a CDN file
  #if [ -f ${PROJECT_PATH}/scripts/cloud/aws/lightsail/_networking.sh ]; then
  #  source ${PROJECT_PATH}/scripts/cloud/aws/lightsail/_networking.sh
  #else
  #  echo "Please check a file : ${PROJECT_PATH}/scripts/cloud/aws/lightsail/_networking.sh"
  #  exit
  #fi
  #echo
}

setDocker() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - Docker"
  echo "---------------------------------------------------------------------------------------------------------------"
}

setVM() {
  echo "---------------------------------------------------------------------------------------------------------------"
  echo "[ $(echo ${ENVIRONMENT_NAME} | tr '[a-z]' '[A-Z]') ] ${PROCESSOR_TYPE} - ${PLATFORM_TYPE} - Scripts - VM"
  echo "---------------------------------------------------------------------------------------------------------------"
  echo

  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then

    # >>>> PHP-FPM
    local PHP_STATUS
    PHP_STATUS=$(sudo systemctl status php-fpm --no-pager | grep "Active:" | awk '{print $2}')
    if [ "${PHP_STATUS}" == "inactive" ]; then
      sudo systemctl start php-fpm
      echo
    fi
    sudo systemctl status php-fpm
    echo

    # >>>> Redis
    local REDIS_STATUS
    REDIS_STATUS=$(sudo systemctl status redis --no-pager | grep "Active:" | awk '{print $2}')
    if [ "${REDIS_STATUS}" == "inactive" ]; then
      sudo systemctl start redis
      echo
    fi
    sudo systemctl status redis --no-pager
    echo

    # >>>> Nginx
    local NGINX_STATUS
    NGINX_STATUS=$(sudo systemctl status nginx --no-pager | grep "Active:" | awk '{print $2}')
    if [ "${NGINX_STATUS}" == "inactive" ]; then
      sudo systemctl start nginx
      echo
    fi
    sudo systemctl status nginx --no-pager
    echo
  fi
  echo
}

# ======================================================================================================================
# Main
# ======================================================================================================================

# >>>> Start
setStart

# >>>> Environment
setEnvironment

# >>>> Platform
setPlatform

# >>>> Project
setProject

# ----------------------------------------------------------------------------------------------------------------------
# Web Server
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
setPhp

# >>>> Cache
setRedis

# >>>> Database
#setPostgreSQL

# >>>> Server
setNginx

# ----------------------------------------------------------------------------------------------------------------------
# Content Delivery
# ----------------------------------------------------------------------------------------------------------------------
#setCDN

# ----------------------------------------------------------------------------------------------------------------------
# Instance
# ----------------------------------------------------------------------------------------------------------------------
setVM

# ----------------------------------------------------------------------------------------------------------------------
# Container
# ----------------------------------------------------------------------------------------------------------------------
#setDocker

# >>>> End
setEnd
