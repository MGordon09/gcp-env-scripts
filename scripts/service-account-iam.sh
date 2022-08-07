#!/bin/bash

service_account_iam(){

    create_new_role #need to create new role following AB template
    create_sa_iam #assign roles to each SA

}

create_new_role(){

    gcloud iam roles create 'Storage bucket and object admin for project' \
        --project $project_name \
        --description 'Storage bucket and object admin for project' \
        --permissions storage.buckets.create,storage.buckets.get,storage.buckets.list,storage.buckets.update,storage.objects.create,storage.objects.get,storage.objects.list

}

create_sa_iam(){

    #gsutil SA roles
    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:gsutil@$project_name.iam.gserviceaccount.com" \
        --role="roles/storage.objectCreator"

    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:gsutil@$project_name.iam.gserviceaccount.com" \
        --role="roles/storage.objectViewer"

    #add newly created role
    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:gsutil@$project_name.iam.gserviceaccount.com" \
        --role="projects/$project_name/roles/Storage bucket and object admin for project"


    #logging-svc SA role
    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:logging-svc@$project_name.iam.gserviceaccount.com" \
        --role="roles/logging.logWriter"

    #nextflow-vm SA roles
    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:nextflow-vm@$project_name.iam.gserviceaccount.com" \
        --role="roles/lifesciences.workflowsRunner"

    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:nextflow-vm@$project_name.iam.gserviceaccount.com" \
        --role="roles/storage.objectAdmin"

    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:nextflow-vm@$project_name.iam.gserviceaccount.com" \
        --role="roles/iam.serviceAccountUser"

    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:nextflow-vm@$project_name.iam.gserviceaccount.com" \
        --role="roles/serviceusage.serviceUsageConsumer"

    #ngs-tools-vm SA roles
    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:ngs-tools-vm@$project_name.iam.gserviceaccount.com" \
        --role="roles/storage.objectCreator"

    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:ngs-tools-vm@$project_name.iam.gserviceaccount.com" \
        --role="roles/storage.objectViewer"

    #ngs-tools SA roles
    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:ngs-tools@$project_name.iam.gserviceaccount.com" \
        --role="roles/storage.objectCreator"

    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:ngs-tools@$project_name.iam.gserviceaccount.com" \
        --role="roles/storage.objectViewer"

    #notebooks SA roles
    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:notebooks@$project_name.iam.gserviceaccount.com" \
        --role="roles/compute.networkUser"

    gcloud projects add-iam-policy-binding $project_name \
        --member="serviceAccount:notebooks@$project_name.iam.gserviceaccount.com" \
        --role="roles/notebooks.runner"

}