#!/bin/bash

#Create custom VPC based on AB mhra-ngs-dev-c0c0 setup

# reset seperators to '-'
project_name=$(reset_var $project_name)
prj_prefix=$(reset_var $prj_prefix)

gcloud compute networks create ${project_name}-network \
    --project=$project_name \
    --subnet-mode=custom --mtu=1460 \
    --bgp-routing-mode=global 

 
# create two subnets xxx-west2-1 & xxx-west2-2
gcloud compute networks subnets create ${prj_prefix}-eu-west2-1 \
    --project=$project_name --range=10.1.0.0/16 \
    --network=$project_name-network --region=europe-west2 \
    --enable-private-ip-google-access --enable-flow-logs \
    --logging-aggregation-interval=interval-5-sec \
    --logging-flow-sampling=0.5 --logging-metadata=include-all 

 
gcloud compute networks subnets create ${prj_prefix}-eu-west2-2 \
    --project=$project_name --range=10.2.0.0/16 \
    --network=$project_name-network --region=europe-west2 \
    --enable-private-ip-google-access --enable-flow-logs \
    --logging-aggregation-interval=interval-5-sec \
    --logging-flow-sampling=0.5 --logging-metadata=include-all 