#!/bin/bash
# addding IAM principals (service accounts and service agents) to all host_prj subnets
#NOTE: principle of least privilage; it may be best to add principals to a single subnet rather than all, so script could be modified. See: https://cloud.google.com/vpc/docs/provisioning-shared-vpc#create-shared

# add nextflow/dsub SA to subnets
gcloud projects add-iam-policy-binding $host_prj \
    --member="serviceAccount:nextflow-vm@$project_name.iam.gserviceaccount.com" \
    --role="roles/compute.networkUser" \
    --project=$project_name

# add conda/singularity SA to subnets
gcloud projects add-iam-policy-binding $host_prj \
    --member="serviceAccount:ngs-tools-vm@$project_name.iam.gserviceaccount.com" \
    --role="roles/compute.networkUser" \
    --project=$project_name

# add notebooks SA to subnets
gcloud projects add-iam-policy-binding $host_prj \
    --member="serviceAccount:notebooks@$project_name.iam.gserviceaccount.com" \
    --role="roles/compute.networkUser" \
    --project=$project_name