#!/bin/bash

# This script is used to extract all project names and numbers with filter to select for projects created from AB template ('mvp' label) 
# TODO: run this in main script and export vars to child processes

prj_id=()
prj_num=()

# this recovers all prj ids for projects under dev/ngs tagged with mvp label. These were created following mhra-ngs-dev-c0c0 template 
for prj in $(gcloud projects list --filter="labels.subservicename=mvp" --format="value(projectId)")

do 
    #append to an array
    prj_id+=( $prj )
    # get prj number and append to second array
    prj_n=$(gcloud projects describe $prj --format="value(projectNumber)")
    prj_num+=( $prj_n )

done