#!/bin/bash

# create new project under parent folder ($parent-id) 

#labelling follows AB set-up 
#label according to env and sub-env (eg dev/ngs)
#also labelled with mvp - this is to ensure we can recover all projects we created incase we need to update/change all simultaneously

servicename=$(echo $project_name | cut -d '-' -f2)
environment=$(echo $project_name | cut -d '-' -f3)

echo gcloud projects create $project_name \
    --folder=$parent_id \
    --labels=costid=2345,user=$folder_name,email=$user_email,environment=$environment,live=yes,servicename=$servicename,subservicename=mvp
