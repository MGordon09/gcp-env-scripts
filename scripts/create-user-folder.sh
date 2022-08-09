#!/bin/bash

# Create user folder for project & resources

gcloud resource-manager folders create \
    --display-name=$folder_name \
    --folder=$parent_id
