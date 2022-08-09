#!/bin/bash

gcloud resource-manager folders add-iam-policy-binding $folder_id \
    --member="user:$user_email" \
    --role='roles/resourcemanager.folderViewer'