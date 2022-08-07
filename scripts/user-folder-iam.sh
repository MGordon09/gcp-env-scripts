#!/bin/bash

# command adds folder viewer IAM role for principal (user identified by email) for the specified
gcloud resource-manager folders add-iam-policy-binding $folder_id \
    --member=$user_email \
    --role='roles/resourcemanager.folderViewer'