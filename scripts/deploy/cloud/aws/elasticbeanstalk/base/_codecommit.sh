#!/bin/bash
# ======================================================================================================================
# Scripts - Cloud - AWS - Elastic Beanstalk - Codecommit
# ======================================================================================================================
# >>>> Environment
if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
  echo "DEV ENVIRONMENT"

  # >>>> AWS - Repositories
  #aws codecommit list-repositories


  # >>>> AWS - Git              https://docs.aws.amazon.com/ko_kr/codecommit/latest/userguide/setting-up-https-unixes.html
  #git config --local credential.helper '!aws codecommit credential-helper $@'
  #git config --local credential.UseHttpPath true
  #git config --local http.sslVerify false
  #echo


elif [ "${ENVIRONMENT_NAME}" == "prod" ]; then
  (
    cd app || return

    # >>>> Symfony Framework                                             https://symfony.com/doc/current/deployment.html
    if [ -f bin/console ]; then

      echo
    fi
  )
else
  echo "Please check environment"
  setEnd
fi