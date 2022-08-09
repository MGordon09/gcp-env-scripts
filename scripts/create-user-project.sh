#!/bin/bash

#create usr project and label according to env and sub-env (eg dev/ngs)
#also labelled with mvp - this is to ensure we can recover all projects we created incase we need to update/change all simultaneously

# reset seperators to '-'
project_name=$(reset_var $project_name)

servicename=$(echo $project_name | cut -d '-' -f2)
environment=$(echo $project_name | cut -d '-' -f3)

gcloud projects create $project_name \
    --folder=$folder_id \
    --labels=costid=2345,user=$folder_name,environment=$environment,live=yes,servicename=$servicename,subservicename=mvp
