#!/bin/bash
# ======================================================================================================================
# Scripts - Cloud - AWS - CDN - S3
# ======================================================================================================================
# >>>> Environment
if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
  echo "DEV ENVIRONMENT"
elif [ "${ENVIRONMENT_NAME}" == "prod" ]; then
  (
    cd app || return

    # >>>> Symfony Framework                                             https://symfony.com/doc/current/deployment.html
    if [ -f bin/console ]; then

      if [ -d public/assets ]; then
        echo ">>>> Resource: public/assets"
        echo

        ls -ltr public/assets
        echo

        echo ">>>> Distribution: ${AMAZON_S3_BUCKET}"
        echo

        # >>>> Public - Delete files

        #aws s3 rm s3://bucket-{name}/build --recursive
        #echo

        # >>>> Public - Upload files

        aws s3 sync public/assets/ s3://${AMAZON_S3_BUCKET}/assets/
        echo

      else
        echo "There is not a folder : public/assets"
      fi
    fi
  )
else
  echo "Please check environment"
  setEnd
fi