#!/bin/bash

# connecting service VPCs created by create-custom-vpc.sh script to host VPC project (CL parameter)
gcloud compute shared-vpc associated-projects add $project_name \
    --host-project $host_prj