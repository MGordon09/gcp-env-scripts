#!/bin/bash

gcloud resource-manager folders create \
    --display-name=$folder_name \
    --folder=$parent_id
