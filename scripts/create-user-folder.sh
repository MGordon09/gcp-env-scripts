#!/bin/bash

gcloud resource-manager folders create \
    --display-name=$folder_name \
    --folder=$parent_id


echo "Getting User Folder ID"

#save folder_id as variable for reuse
#folder_id=$( gcloud resource-manager folders list --folder=$parent_name --filter="DISPLAY_NAME=$folder_name" --format="value(ID)" )

#echo $folder_id



# extract gcp variables 
#source ./get-projects.sh 

#if [ "x$1" == "x" -o "x$2" == "x" ]; then #type and seqencing output folder must be set
#  echo "Usage: $0 folder-name parent-folder-id" 
#  exit
#fi

#gcloud resource-manager folders create  --display-name=$folder_name --folder=$parent_folder 