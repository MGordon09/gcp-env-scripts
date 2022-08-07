#!/bin/bash

#IAM roles for gsutil service account

user_account_iam(){

    create_user_iam #assign roles to user

}


create_user_iam(){

    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/compute.networkUser"

    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/notebooks.admin"

    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/compute.instanceAdmin"

    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/compute.osAdminLogin"

    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/iap.tunnelResourceAccessor"
    
    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/iap.httpsResourceAccessor"

    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/owner"
    
    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/iam.serviceAccountUser"  

    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/storage.admin"

    gcloud projects add-iam-policy-binding $project_name \
        --member="user:$user_email" \
        --role="roles/viewer"
    
}