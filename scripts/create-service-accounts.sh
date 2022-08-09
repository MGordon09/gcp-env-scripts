#!/bin/bash

# create service accounts to allow interactions between GCP serivces 

# reset seperators to '-'
project_name=$(reset_var $project_name)

# SA used to authenticate when transferring data from on-site HPC to GCS bucket
gcloud iam service-accounts create gsutil \
    --project=$project_name \
    --display-name=$project_name-gsutil \
    --description="'Service account for gsutil on-prem data transfers'"

# SA used for logging and monitoring actions
gcloud iam service-accounts create logging-svc \
    --project=$project_name \
    --display-name=$project_name-logging-svc \
    --description="'Service account for logging & monitoring'"

# SA used to access all Nextflow and dsub VMs
gcloud iam service-accounts create nextflow-vm \
    --project=$project_name \
    --display-name=$project_name-nextflow-vm \
    --description="'Service account for Nextflow/DSub VMs'"

# SA used to access ngs-tools VM (w write permissions to GCS)
gcloud iam service-accounts create ngs-tools \
    --project=$project_name \
    --display-name=$project_name-ngs-tools \
    --description="'Service account for Conda/Singularity tools VM with permissions to write to cloud storage'"

# SA used to access ngs-tools VM
gcloud iam service-accounts create ngs-tools-vm \
    --project=$project_name \
    --display-name=$project_name-ngs-tools-vm \
    --description="'Service account for Conda/Singularity tools VM'"

# SA used to access Vertex AI notebooks
gcloud iam service-accounts create notebooks \
    --project=$project_name \
    --display-name=$project_name-notebooks \
    --description="'Service account for Vertex AI notebooks'"