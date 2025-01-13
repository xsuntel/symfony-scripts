#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Abstract
# ======================================================================================================================

# >>>> Environment
if [ -f ${PROJECT_PATH}/.env.app ]; then
  source ${PROJECT_PATH}/.env.app
else
  echo "Please check .env file : ${PROJECT_PATH}/.env.app" && exit
fi

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
  echo ">>>>  START                                                                  $(date)"
  echo "==============================================================================================================="
  # >>>> Current Path
  echo "- CURRENT PATH : $(realpath ${PWD})"
  echo
}

# ----------------------------------------------------------------------------------------------------------------------
# Scripts - End
# ----------------------------------------------------------------------------------------------------------------------

setEnd() {
  # --------------------------------------------------------------------------------------------------------------------
  # Main
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Environment
  unset ENVIRONMENT_NAME
  unset DOCKER_ENVIRONMENT
  unset DOCKER_WORKDIR
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

  # --------------------------------------------------------------------------------------------------------------------
  # Software Bundles
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> App
  unset PHP_VERSION
  unset PHP_NETWORK_FRONTEND_IP_ADDRESS
  unset PHP_NETWORK_BACKEND_IP_ADDRESS
  unset SYMFONY_VERSION

  unset NODE_VERSION

  # >>>> Cache
  unset REDIS_VERSION
  unset REDIS_NETWORK_FRONTEND_IP_ADDRESS
  unset REDIS_NETWORK_BACKEND_IP_ADDRESS
  unset REDIS_NETWORK_PORT
  unset REDIS_HOST
  unset REDIS_PORT
  unset REDIS_ROOT_USER
  unset REDIS_ROOT_PASSWORD

  # >>>> Database
  unset MYSQL_VERSION
  unset MYSQL_NETWORK_FRONTEND_IP_ADDRESS
  unset MYSQL_NETWORK_BACKEND_IP_ADDRESS
  unset MYSQL_NETWORK_PORT
  unset MYSQL_HOST
  unset MYSQL_PORT
  unset MYSQL_DB
  unset MYSQL_USER
  unset MYSQL_PASSWORD

  unset POSTGRES_VERSION
  unset POSTGRES_NETWORK_FRONTEND_IP_ADDRESS
  unset POSTGRES_NETWORK_BACKEND_IP_ADDRESS
  unset POSTGRES_NETWORK_PORT
  unset POSTGRES_HOST
  unset POSTGRES_PORT
  unset POSTGRES_DB
  unset POSTGRES_USER
  unset POSTGRES_PASSWORD

  # >>>> Messenger
  unset RABBITMQ_VERSION
  unset RABBITMQ_NETWORK_FRONTEND_IP_ADDRESS
  unset RABBITMQ_NETWORK_BACKEND_IP_ADDRESS
  unset RABBITMQ_HOST
  unset RABBITMQ_PORT
  unset RABBITMQ_USER
  unset RABBITMQ_PASSWORD

  # >>>> Server
  unset APACHE_VERSION
  unset APACHE_NETWORK_FRONTEND_IP_ADDRESS
  unset APACHE_NETWORK_BACKEND_IP_ADDRESS
  unset APACHE_NETWORK_PORT
  unset APACHE_HOST
  unset APACHE_PORT
  unset APACHE_HEALTHCHECK_FILE

  unset NGINX_VERSION
  unset NGINX_NETWORK_FRONTEND_IP_ADDRESS
  unset NGINX_NETWORK_BACKEND_IP_ADDRESS
  unset NGINX_NETWORK_PORT
  unset NGINX_HOST
  unset NGINX_PORT
  unset NGINX_HEALTHCHECK_FILE

  # --------------------------------------------------------------------------------------------------------------------
  # Content Delivery
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Cloud - AWS
  unset PYTHON_VERSION
  unset AWSCLI_VERSION

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

  # --------------------------------------------------------------------------------------------------------------------
  # Container
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Docker
  unset DOCTRINE_COMMAND

  # --------------------------------------------------------------------------------------------------------------------
  # Instance
  # --------------------------------------------------------------------------------------------------------------------


  # --------------------------------------------------------------------------------------------------------------------
  # Tools
  # --------------------------------------------------------------------------------------------------------------------

  # >>>> Mail
  unset MAILER_NETWORK_BACKEND_IP_ADDRESS
  unset MAILER_NETWORK_HTTP_PORT
  unset MAILER_NETWORK_SMTP_PORT

  # >>>> PgAdmin
  unset PGADMIN_NETWORK_BACKEND_IP_ADDRESS
  unset PGADMIN_HOST
  unset PGADMIN_PORT
  unset PGADMIN_MAIL
  unset PGADMIN_PW

  echo
  echo "==============================================================================================================="
  echo "<<<<  END                                                                    $(date)"
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
  # >>>> Process
  kill -SIGKILL $$
  echo
  exit
}