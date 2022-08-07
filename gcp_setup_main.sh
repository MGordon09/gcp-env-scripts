#!/bin/bash 

set -euo pipefail 

# ------------------------------------------------------------------------------
# Overview
# Script to create and configure new user GCP projects using mhra-ngs-dev-c0c0 as template
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Return Help Page  
# ------------------------------------------------------------------------------

if [ "x$1" == "x" -o "x$2" == "x" -o "x$3" == "x"  -o "x$4" == "x" ]; then #TODO maybe set specific variables
  echo "Usage: $0 foldername[e.g jblogs] parent-folder-id[e.g 12345678] user-email[e.g joe.blogs@nibsc.org] source-image-project[xxx-xxx-xxx-xxx] (Optional)host-vpc-project[xxx-xxx-xxx-xxx]

  For parent folder ID, use cloud console or run ` gcloud resource-manager folders list --organization ORGIDNUMBER ` to list all folder details (need org id num)
  (Optional) If connecting to new project to a host VPC, add host project name as fifth CL parameter when invoking script  
  "
  exit
fi

# ------------------------------------------------------------------------------
# Common Variables 
# ------------------------------------------------------------------------------

# export command so env variables passed to child processes
set_variables(){
    export folder_name=$1
    export parent_id=$2
    export user_email=$3
    export shr_prj=$4 #Required for creating instance templates
    export host_prj=$5 #Required for connecting to host VPC project
    export parent_name=$(gcloud resource-manager folders describe --folder=$parent_id --format='value(displayName)')
    export billing_account_id=$(gcloud beta billing accounts list --format='value(ACCOUNT_ID)')
    export folder_id=$(gcloud resource-manager folders list --folder=$parent_id --filter="DISPLAY_NAME=$folder_name" --format="value(ID)") #user folder must exist -put in later code block

    # create prj name variable here to pass to child processes
    export prj_prefix=$(gcloud projects list --filter="parent.id: $parent_id" --format="value(NAME)" --limit=1 | cut -d "-" -f1-3)
    export prj_suffix=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c4) #four random alphanumeric characters
    export project_name=${prj_prefix}-${prj_suffix}
}

gcp_project_setup_main(){
   
   get_project_info #get project name and id
   create_folder #optional: create a new user folder under parent folder
   iam_roles_folder #give user viewer IAM role for folder
   create_project #create new user project
   billing_project #set up billing for the project
   create_buckets #create input, output and nextflow buckets for each project
   #create_lifecycle_rules #LEAVE OFF. Adjust lifecycle rules for bucket but cant set last access time as a condition so $$$ to implement...
   create_custom_vpc
   connect_host_vpc #WARNING: must supply host VPC project on script execution
   create_firewall_rules #NOTE: applied only if not connecting to a host VPC. Only create FW rule for ssh VM connection
   create_service_accounts
   service_account_iam
   user_account_iam
   create_instance_templates
   add_vm_oslogin #add oslogin = TRUE to project-wide VM instances to link linux VM UID to GCP user/SA 
   enable_project_api
   #iam-policy-binding.sh #attach SA and google amanged service agents to the host project - compare AB service project 

}

# NB think i need to run this loop in parent process as cant retrieve the variables
get_project_info(){
    echo "Getting User Project Details..."

    bash ./scripts/get-gcp-projects.sh 

    echo "Complete!"   
}

create_folder(){

    if [ "x$1" == "x" -o "x$2" == "x" -o "x$3" == "x" ]; then
        echo "Skipping Folder Creation..."
    else
        echo "Creating User Folder"
        bash ./scripts/create-user-folder.sh
        echo "Complete!"
        echo $folder_id
    fi
}

iam_roles_folder(){
    echo "Add Folder Viewer Roles For User..."

    bash ./scripts/user-folder-iam.sh

    echo "Complete!" 
}

create_project(){
    echo "Creating Project $project_name Under $parent_id..."

    bash ./scripts/create-user-project.sh

    echo "Complete!"

}

billing_project(){
    echo "Setting billing for $project_name..."

    bash ./scripts/billing-setup-project.sh

    echo "Complete!"

}

create_buckets(){
    echo "Creating buckets and bucket labesl for $project_name..."

    bash ./scripts/create-project-buckets.sh

    echo "Complete!"
}

create_lifecycle_rules(){
    echo "Creating bucket lifecycle management policy"
    echo "policy applied from ./docs/nibsc-bucket-lifecycle-policy.json"

    bash ./scripts/create-bucket-lifecycle.sh

    echo "Complete!"
}

create_custom_vpc(){
    echo "Creating custom VPC and subnets for $project_name..."

    bash ./scripts/create-custom-vpc.sh

    echo "Complete!"
}

connect_host_vpc(){

    if [ "x$5" == "x" ]; then
        echo "Skipping host VPC connection..."
    else
        echo "Connecting $project_name-network to host VPC project..."
        bash ./scripts/connect-host-vpc.sh
        echo "Complete!"
    fi
}

create_firewall_rules(){

    if [ "x$5" == "x" ]; then
        echo "Implementing base firewall rules"
        bash ./scripts/create-firewall-rules.sh
        echo "Complete!"
    else
        echo "Skipping firewall rule implementation. Inheriting rules from host VPC project"
    fi
}

create_service_accounts(){
    echo "Creating service accounts for $project_name..."
    
    bash ./scripts/create-service-accounts.sh
    
    echo "Complete!"
}

service_account_iam(){
    echo "Creating IAM roles for service accounts..."

    bash ./scripts/service-account-iam.sh

    echo "Complete!"
}

user_account_iam(){
    echo "Creating IAM roles for user accounts..."

    bash ./scripts/user-account-iam.sh

    echo "Complete!"
}

create_instance_templates(){
    echo "Creating VM instance templates..."

    bash ./scripts/create-instance-templates.sh

    echo "Complete!"
}

add_vm_oslogin(){
    echo "Enabling project-wide os-login..."

    bash ./scripts/add-oslogin-metadata.sh

    echo "Complete!"
}

enable_project_api(){
    echo "Enabling services for $project_name..."

    bash ./scripts/add-oslogin-metadata.sh

    echo "Complete!"
}

iam_policy_binding(){
    echo "Enabling IAM policy binding for $project_name principals..."

    bash ./scripts/iam-policy.sh

    echo "Complete!"
}
