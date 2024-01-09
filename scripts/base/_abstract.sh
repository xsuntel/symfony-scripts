#!/bin/bash
# ======================================================================================================================
# Scripts - Abstract - Default variables
# ======================================================================================================================
# >>>> Platform
PLATFORM_TYPE=$(uname -s)
PROCESSOR_TYPE=$(uname -m)

# >>>> Project
PROJECT_NAME=$(basename "$(realpath ${PROJECT_PATH})")

# ----------------------------------------------------------------------------------------------------------------------
# Scripts - Start
# ----------------------------------------------------------------------------------------------------------------------

setStart() {
  echo
  echo "==============================================================================================================="
  echo "  START                                                                      $(date)"
  echo "==============================================================================================================="
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux - Ubuntu
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    echo "- CURRENT PATH : $(realpath ${PWD})"
  else
    echo "Please check Operating System"
    setEnd
  fi
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Scripts - End
# ----------------------------------------------------------------------------------------------------------------------

setEnd() {
  # --------------------------------------------------------------------------------------------------------------------
  # App
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Abstract
  unset ABSTRACT_NAME

  # >>>> Environment
  unset ENVIRONMENT_NAME
  unset DOCKER_ENVIRONMENT
  unset DOCKER_NETWORK_FRONTEND_IPAM_CONFIG_SUBNET
  unset DOCKER_NETWORK_BACKEND_IPAM_CONFIG_SUBNET

  # >>>> Platform
  unset PROCESSOR_TYPE
  unset PLATFORM_TYPE
  unset PLATFORM_TIMEZONE

  # >>>> Project
  unset PROJECT_NAME
  unset PROJECT_PATH
  unset PROJECT_WORKDIR

  # >>>> App
  unset PHP_VERSION
  unset PHP_FRAMEWORK_VERSION
  unset PHP_NETWORK_FRONTEND_IP_ADDRESS
  unset PHP_NETWORK_BACKEND_IP_ADDRESS
  unset NODE_VERSION
  unset NODE_NETWORK_FRONTEND_IP_ADDRESS

  # >>>> Cache
  unset MEMCACHED_VERSION
  unset MEMCACHED_HOST
  unset MEMCACHED_PORT
  unset REDIS_VERSION
  unset REDIS_NETWORK_BACKEND_IP_ADDRESS
  unset REDIS_HOST
  unset REDIS_PORT
  unset REDIS_ROOT_USER
  unset REDIS_ROOT_PASSWORD

  # >>>> Database
  unset MONGO_VERSION
  unset MYSQL_VERSION
  unset MYSQL_NETWORK_BACKEND_IP_ADDRESS
  unset MYSQL_HOST
  unset MYSQL_PORT
  unset MYSQL_DB
  unset MYSQL_USER
  unset MYSQL_PASSWORD
  unset POSTGRESQL_VERSION
  unset POSTGRES_NETWORK_BACKEND_IP_ADDRESS
  unset POSTGRES_HOST
  unset POSTGRES_PORT
  unset POSTGRES_DB
  unset POSTGRES_USER
  unset POSTGRES_PASSWORD

  # >>>> Server
  unset APACHE_VERSION
  unset APACHE_NETWORK_FRONTEND_IP_ADDRESS
  unset APACHE_PORT
  unset NGINX_VERSION
  unset NGINX_NETWORK_FRONTEND_IP_ADDRESS
  unset NGINX_PORT

  # >>>> AWS - S3
  unset AMAZON_S3_DOMAIN
  unset AMAZON_S3_KEY
  unset AMAZON_S3_SECRET
  unset AMAZON_S3_BUCKET
  unset AMAZON_S3_REGION
  unset AMAZON_S3_VERSION

  # >>>> AWS - SES
  unset MAILER_ACCESS_KEY
  unset MAILER_SECRET_KEY

  # >>>> Mail
  unset MAILER_NETWORK_BACKEND_IP_ADDRESS
  unset PGADMIN_NETWORK_BACKEND_IP_ADDRESS
  unset PGADMIN_HOST
  unset PGADMIN_PORT
  unset PGADMIN_MAIL
  unset PGADMIN_PW

  # --------------------------------------------------------------------------------------------------------------------
  # Scripts
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Cloud - AWS
  unset PYTHON_VERSION
  unset AWSCLI_VERSION

  # --------------------------------------------------------------------------------------------------------------------
  # Tools
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> PhpStorm
  unset OPENJDK_VERSION
  unset PHPSTORM_VERSION
  unset VSCODE_VERSION

  echo
  echo "==============================================================================================================="
  echo "  END                                                                        $(date)"
  echo "==============================================================================================================="
  echo
  exit 0
}

# ----------------------------------------------------------------------------------------------------------------------
# Scripts - Exit
# ----------------------------------------------------------------------------------------------------------------------

setExit() {
  echo
  echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  echo "  EXIT                                                                      $(date)"
  echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
  echo
  # >>>> Platform
  if [ "${PLATFORM_TYPE}" == "Linux" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Linux
    # ------------------------------------------------------------------------------------------------------------------
    kill -SIGKILL $$
  elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # MacOS
    # ------------------------------------------------------------------------------------------------------------------
    kill -SIGKILL $$
  elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
    # ------------------------------------------------------------------------------------------------------------------
    # Windows
    # ------------------------------------------------------------------------------------------------------------------
    kill -SIGKILL $$
  else
    echo "Please check Operating System"
    setEnd
  fi
  echo
  exit
}