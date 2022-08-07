#!/bin/bash

#enabling APIs on project
gcloud services enable accesscontextmanager.googleapis.com aiplatform.googleapis.com autoscaling.googleapis.com bigquery.googleapis.com bigquerystorage.googleapis.com billingbudgets.googleapis.com \
    --project=$project_name

gcloud services enable cloudbilling.googleapis.com cloudfunctions.googleapis.com cloudresourcemanager.googleapis.com compute.googleapis.com container.googleapis.com containeranalysis.googleapis.com containerfilesystem.googleapis.com containerregistry.googleapis.com \
    --project=$project_name

gcloud services enable dns.googleapis.com file.googleapis.com genomics.googleapis.com iam.googleapis.com iamcredentials.googleapis.com iap.googleapis.com lifesciences.googleapis.com logging.googleapis.com monitoring.googleapis.com notebooks.googleapis.com \
    --project=$project_name

gcloud services enable osconfig.googleapis.com oslogin.googleapis.com pubsub.googleapis.com serviceusage.googleapis.com source.googleapis.com storage-api.googleapis.com \
    --project=$project_name