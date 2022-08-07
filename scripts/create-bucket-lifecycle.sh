#!/bin/bash

#setting lifecycle policy on bucket
# not a good idea as no way to set based on access date, so could incur excessive charges for bucket access if in colder storage

buckets=('input' 'output' 'nextflow')

for b in ${buckets[@]}; do

    gsutil lifecycle set \
    ./docs/nibsc-bucket-lifecycle-policy.json gs://${project_name}-${b}
        
done