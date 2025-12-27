#!/bin/bash
# ======================================================================================================================
# Scripts - Cloud - GCP (Google Cloud Platform) - Cloud Run
# ======================================================================================================================

echo ">>>> GCP - Cloud Code"
echo

#docker push
echo

# ----------------------------------------------------------------------------------------------------------------------
# GCP - Cloud Build
# ----------------------------------------------------------------------------------------------------------------------

echo ">>>> GCP - Cloud Build"
echo

#gcloud builds submit --tag {europe-west4-docker.pkg.dev}/{PROJECT_ID}/{webapp_repo}/{image_name}:{tag}
echo

# ----------------------------------------------------------------------------------------------------------------------
# GCP - Artifact Registry
# ----------------------------------------------------------------------------------------------------------------------

echo ">>>> GCP - Artifact Registry"
echo

#docker build . --tag {europe-west4-docker.pkg.dev}/{PROJECT_ID}/{webapp_repo}/{image_name}:{tag}
#docker push {europe-west4-docker.pkg.dev}/{PROJECT_ID}/{webapp_repo}/{image_name}:{tag}
echo

