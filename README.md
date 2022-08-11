# GCP Environment Startup Scripts

This repo contains scripts to create user folder, project and resources according to MVP GCP project template

## Prerequisites

The following is required to run this pipeline:
- A GCP user account with elevated (org-level) privilages to create GCP resources including projects
- Access to GCloud or Cloud SDK to run the script

## Getting Started

1. Authenticate user account by running `gcloud auth login` on gcloud terminal or CL with cloud SDK installed

2. Clone the github repo and navigate to its root directory

```
git clone https://github.com/MGordon09/gcp-env-scripts.git
cd gcp-env-scripts
```

3. To create all resources from scratch, just run the main script and provide the following 5 command-line arguments **in specific order**:

- **user folder name** the username for the folder containing resources. Our convention is first name inital and second name (e.g jblogs) 
- **parent folder ID** the ID of the parent folder the user folder will sit under. This is the folders numeric identifier and can be found using the GCP console to view org hierarchy
- **user email** email for the principal (e.g joe.blogs@nibsc.org) 
- **share project** name of project that contains resources that are shared with other projects (e.g images for instance template creation)
- **billing account id** billing account id. This can be found by looking up the 'MY PROJECTS' tab of the GCP Billing Service
- **host project** (*Optional*) Specify name of host project to connect the new project and use a shared VPC setup. This can be left empty if you wish to create a standalone project, although you will need to manually configure the firewall rules (edit `create-firewall-rules.sh` script)

```
# run script with shared VPC set-up
bash gcp_setup_main.sh 'jblogs' '123456789012' 'joe.blogs@xxx.org' 'share-proj-id' 'billing-account-id' 'host-prj-id'
```

**NOTE**
The script is quite modular, so it is relatively simple to edit and run any of the scripts called by `gcp_setup_main.sh`. It is also possible to turn on/off different modules to alter the workflow by editing the following section in `gcp_setup_main.sh`. 
Edit the workflow section of the script and hash out any processes you don't want to run (or you can create new ones!)

```
section of script to edit: remove processes by commenting out lines. See `create-lifecycle-rules`

#------------------------------------------------------------------------------
# Workflow
#------------------------------------------------------------------------------
# Note: you can modify the gcp_project_setup_main() workflow run by hashing out steps or adding new ones

gcp_project_setup_main(){
   
   set_variables # <- DO NOT DISABLE!
   create_folder #optional: create a new user folder under parent folder
   iam_roles_folder #give user viewer IAM role for folder
   create_project #create new user project
   billing_project #set up billing for the project
   create_buckets #create input, output and nextflow buckets for each project
   enable_project_api
   #create_lifecycle_rules #LEAVE OFF. Adjust lifecycle rules for bucket but cant set last access time as a condition so $$$ to implement...
   create_custom_vpc
   connect_host_vpc #WARNING: must supply host VPC project on script execution 
   create_firewall_rules #NOTE: applied only if not connecting to a host VPC. Only create FW rule for ssh VM connection #Done
   create_service_accounts #create service accounts to authenticate to VMs
   service_account_iam #set IAM roles for service accounts
   user_account_iam #set IAM roles for user account
   create_instance_templates #create templates for VM creation
   add_vm_oslogin #add oslogin = TRUE to project-wide VM instances to link linux VM UID to GCP user/SA  
   iam_policy_binding #attach SA and google amanged service agents to the host project - compare AB service project 

}
```


4. After running script, go to IAM & Admin -> Organisation Policies. Search for 'Define allowed external IPs for VM instances'. Edit the policy -> create a custom policy -> Select Allow All -> Select Done and save
