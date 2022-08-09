#!/bin/bash

#enabling APIs on project
# could execute as one command but more readable.. maybe put in array?
# reset seperators to '-'
project_name=$(reset_var $project_name)

#enabling APIs on project - cant do in more than batches of 20 so split
gcloud services enable \
    accesscontextmanager.googleapis.com aiplatform.googleapis.com autoscaling.googleapis.com bigquery.googleapis.com \
    bigquerystorage.googleapis.com billingbudgets.googleapis.com cloudbilling.googleapis.com cloudfunctions.googleapis.com cloudresourcemanager.googleapis.com \
    compute.googleapis.com container.googleapis.com containeranalysis.googleapis.com containerfilesystem.googleapis.com containerregistry.googleapis.com \
    --project=$project_name

gcloud services enable \
    dns.googleapis.com file.googleapis.com genomics.googleapis.com iam.googleapis.com iamcredentials.googleapis.com iap.googleapis.com lifesciences.googleapis.com \
    logging.googleapis.com monitoring.googleapis.com notebooks.googleapis.com osconfig.googleapis.com oslogin.googleapis.com pubsub.googleapis.com serviceusage.googleapis.com \
    storage-api.googleapis.com \
    --project=$project_name

    # source.googleapis.com - could not enable this API so removed.... doesnt seem to impact functionality