#!/bin/bash 

set -euo pipefail #exit if non-zero exit status, unset variables found and prevent masking errors in pipeline
# ------------------------------------------------------------------------------
# Overview
# Script to create and configure new user GCP projects using mhra-ngs-dev-c0c0 as template
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Return Help Page  
# ------------------------------------------------------------------------------

if [[ -z "${1}" || -z "${2}" || -z "${3}" || -z "${4}" ]]; then #TODO maybe set specific variables
  echo "Usage: $0 foldername[e.g jblogs] parent-folder-id[e.g 12345678] user-email[e.g joe.blogs@nibsc.org] source-image-project[xxx-xxx-xxx-xxx] (Optional)host-vpc-project[xxx-xxx-xxx-xxx]

  For parent folder ID, use cloud console or run ` gcloud resource-manager folders list --organization ORGIDNUMBER ` to list all folder details (need org id num)
  (Optional) If connecting to new project to a host VPC, add host project name as fifth CL parameter when invoking script  
  "
  exit
fi


# ------------------------------------------------------------------------------
# Define Common Variables 
# ------------------------------------------------------------------------------

#CL variables to export to subprocess
folder_name=$1 #username folder eg jblogs
parent_id=$2 #direct parent folder id
user_email=$3 #principal
shr_prj=$4 #Required for creating instance templates
host_prj=$5 #Required for connecting to host VPC project

# define variables to export to subprocesses
# '-' illegal export charactger; convert '_', export and reset in subprocess
parent_name=$(gcloud resource-manager folders describe $parent_id --format='value(displayName)')
billing_account_id=$(gcloud beta billing accounts list --format='value(ACCOUNT_ID)' | sed 's/-/_/g')
prj_prefix=$(gcloud projects list --filter="parent.id: $parent_id" --format="value(NAME)" --limit=1 | cut -d "-" -f1-3 | sed 's/-/_/g')
prj_suffix=$(head /dev/urandom | tr -dc a-z0-9 | head -c4) #four random alphanumeric characters
project_name=${prj_prefix}_${prj_suffix}

# func to reset variable names after export
reset_var(){
    echo $1 | sed 's/_/-/g'
}

#Note: to implement any of these scripts for an available project, just name the project and uncomment lines below
#project_name='mhra_ngs_dev_mr2s' #use underscores as replaced in subprocesses
#export project_name

#------------------------------------------------------------------------------
# Workflow
#------------------------------------------------------------------------------
# Note: you can modify the gcp_project_setup_main() workflow run by hashing out steps or adding new ones

gcp_project_setup_main(){
   
   set_variables # <- DO NOT DISABLE!
   create_folder #Optional: create a new user folder under parent folder
   export_folder_id # <- DO NOT DISABLE!
   create_project #create new user project
   billing_project #set up billing for the project
   create_buckets #create input, output and nextflow buckets for each project
   enable_project_api #enable GCP services (Note: API list could be refined)
   #create_lifecycle_rules #LEAVE OFF! Adjust lifecycle rules for bucket but cant set last access time as a condition so $$$ to implement...
   create_custom_vpc #create vpc network (global resource) and subnets (regional) according to AB specifications
   connect_host_vpc #Optional: connect user project to a pre-configured host-VPC projectWARNING: must supply host VPC project on script execution 
   create_firewall_rules #Optional: NOTE - applied only if not connecting to a host VPC. Only FW rule for ssh VM connection enabled, add others to script as required 
   create_service_accounts #create service accounts to authenticate to VMs
   service_account_iam #set IAM roles for service accounts
   user_account_iam #set IAM roles for user account
   create_instance_templates #create templates for VM creation
   add_vm_oslogin #add oslogin = TRUE to project-wide VM instances to link linux VM UID to GCP user/SA  
   iam_policy_binding #attach SA and google amanged service agents to the host project - compare AB service project
   iam_roles_folder #give user viewer IAM role for folder

}


# export command so env variables passed to child processes
set_variables(){
    export folder_name
    export parent_id
    export user_email
    export shr_prj
    export host_prj
    export parent_name
    export billing_account_id
    export prj_prefix
    export prj_suffix
    export project_name
    export -f reset_var #export function
}


create_folder(){
    echo "Creating User Folder"
    
    bash ./scripts/create-user-folder.sh

    echo "Complete!"
    sleep 5m
}

export_folder_id(){
    echo "Getting User Folder ID..."

    # create and export folder_id variable
    folder_id=$(gcloud resource-manager folders list --folder=$parent_id --filter="DISPLAY_NAME=$folder_name" --format="value(ID)") 
    export folder_id

    echo "Complete!"
    sleep 2m
}

create_project(){
    echo "Creating Project $project_name Under $folder_id..."

    bash ./scripts/create-user-project.sh

    echo "Complete!"
    sleep 2m
}

billing_project(){
    echo "Setting billing for $project_name..."

    bash ./scripts/billing-setup-project.sh

    echo "Complete!"
    sleep 2m
}

create_buckets(){
    echo "Creating buckets and bucket labels for $project_name..."

    bash ./scripts/create-project-buckets.sh

    echo "Complete!"
    sleep 2m
}

create_lifecycle_rules(){
    echo "Creating bucket lifecycle management policy"
    echo "policy applied from ./docs/nibsc-bucket-lifecycle-policy.json"

    bash ./scripts/create-bucket-lifecycle.sh

    echo "Complete!"
    sleep 2m
}

create_custom_vpc(){
    echo "Creating custom VPC and subnets for $project_name..."

    bash ./scripts/create-custom-vpc.sh

    echo "Complete!"
    sleep 2m
}

connect_host_vpc(){

    if [[ -z "${host_prj}" ]]; then
        echo "Skipping host VPC connection..."
    else
        echo "Connecting $project_name-network to host VPC project..."
        bash ./scripts/connect-host-vpc.sh
        echo "Complete!"
    fi
    sleep 2m
}

create_firewall_rules(){

    if [[ -z "${host_prj}" ]]; then
        echo "Implementing base firewall rules"
        bash ./scripts/create-firewall-rules.sh
        echo "Complete!"
    else
        echo "Skipping firewall rule implementation. Inheriting rules from host VPC project"
    fi
    sleep 2m
}

create_service_accounts(){
    echo "Creating service accounts for $project_name..."
    
    bash ./scripts/create-service-accounts.sh
    
    echo "Complete!"
    sleep 2m
}

service_account_iam(){
    echo "Creating IAM roles for service accounts..."

    bash ./scripts/service-account-iam.sh

    echo "Complete!"
    sleep 2m
}

user_account_iam(){
    echo "Creating IAM roles for user accounts..."

    bash ./scripts/user-account-iam.sh

    echo "Complete!"
    sleep 2m
}

create_instance_templates(){
    echo "Creating VM instance templates..."

    bash ./scripts/create-instance-templates.sh

    echo "Complete!"
    sleep 2m
}

add_vm_oslogin(){
    echo "Enabling project-wide os-login..."

    bash ./scripts/add-oslogin-metadata.sh

    echo "Complete!"
    sleep 2m
}

enable_project_api(){
    echo "Enabling services for $project_name..."

    bash ./scripts/enable-project-api.sh

    echo "Complete!"
    sleep 2m
}

iam_policy_binding(){
    echo "Enabling IAM policy binding for $project_name principals..."

    bash ./scripts/iam-policy-binding.sh

    echo "Complete!"
    sleep 2m
}

iam_roles_folder(){
    echo "Add Folder Viewer Roles For User..."

    bash ./scripts/user-folder-iam.sh

    echo "Complete!"
    sleep 2m 
}

#------------------------------------------------------------------------------
# Run Workflow
#------------------------------------------------------------------------------

gcp_project_setup_main

echo "Workflow Complete!"