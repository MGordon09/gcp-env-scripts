#!/bin/bash

#add oslogin = TRUE to project-wide VM instances to link linux VM UID to GCP user/SA with necessary privilages for additional security
# remember user must have sufficient IAM roles to access the VM: see https://cloud.google.com/compute/docs/oslogin/set-up-oslogin#gcloud for further info 
gcloud compute project-info add-metadata \
    --project=$project_name \
    --metadata enable-oslogin=TRUE