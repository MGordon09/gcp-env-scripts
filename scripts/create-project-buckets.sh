#!/bin/bash

# creating, nextflow, input and output buckets for the project
# creating 3 by default - can add more as required

# for labelling
servicename=$(echo $project_name | cut -d '-' -f2)
environment=$(echo $project_name | cut -d '-' -f3)
datelab=$(`date +'%d-%m-%y'`)

# gsutil mb Parameters
# -l bucket location: europe-west2
# -c storage class: standard
# -p project: where bucket is created
# --pap public access to buckets restricted
# -b uniform-level access to objects in bucket

buckets=('input' 'output' 'nextflow')

for b in ${buckets[@]}; do

    gsutil mb gs://${project_name}-${b} \
        -p $project_name \
        -l 'europe-west2' \
        -c 'Standard' \
        -b 'on' \
        --pap 'enforced' 

    #adding labels to bucket
    gsutil label ch -l project:$project_name -l user:$folder_name \
        -l email:$user_email -l environment:$environment \
        -l servicename:$servicename creation-date:$datelab \
        gs://${project_name}-${b}

done