#!/bin/bash

# connecting service VPCs created by create-custom-vpc.sh script to host VPC project (CL parameter)

# reset seperators to '-'
project_name=$(reset_var $project_name)

gcloud compute shared-vpc associated-projects add $project_name \
    --host-project $host_prj