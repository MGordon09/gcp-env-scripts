#!/bin/bash

# creating, nextflow, input and output buckets for the project
# creating 3 by default - can add more as required

# reset seperators to '-'
project_name=$(reset_var $project_name)

# for labelling
servicename=$(echo $project_name | cut -d '-' -f2)
environment=$(echo $project_name | cut -d '-' -f3)
datelab=$(date +'%d-%m-%y')

# gsutil mb Parameters
# -l bucket location: europe-west2
# -c storage class: standard
# -p project: where bucket is created
# --pap public access to buckets restricted
# -b uniform-level access to objects in bucket

buckets=('input' 'output' 'nextflow')

for b in ${buckets[@]}; do

    gsutil mb \
        -p $project_name \
        -l 'europe-west2' \
        -c 'Standard' \
        -b 'on' \
        --pap 'enforced' \
        gs://${project_name}-${b}

    #adding labels to bucket
    gsutil label ch -l project:$project_name -l user:$folder_name -l environment:$environment -l servicename:$servicename -l creation-date:$datelab gs://${project_name}-${b}

done