# GCP Environment Startup Scripts

This repo contains scripts to create user folder, project and resources according to MVP GCP project template

## Prerequisites

The following is required to run this pipeline:
- A GCP user account with elevated privileges (organisation-level admin) to create GCP resources including projects
- Permissions adequate to link the project to the target Cloud Billing account. Both project permissions and billing account permissions are required. Review https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_project for an overview of IAM roles required.
- Access to gcloud or Cloud SDK to run the script

## Getting Started

1. Authenticate user account by running `gcloud auth login` on gcloud terminal or CL with cloud SDK installed

2. Clone the github repo and navigate to its root directory. 

```
git clone https://github.com/MGordon09/gcp-env-scripts.git
chmod -R u+x ./gcp-env-scripts #make scripts executable
cd gcp-env-scripts
```

3. To create all resources from scratch, just run the main script and provide the following 5 command-line arguments **in specific order**:

- **user folder name** the username for the folder containing resources. Our convention is first name inital and second name (e.g jblogs) 
- **parent folder ID** the ID of the parent folder the user folder will sit under. This is the folders numeric identifier and can be found using the GCP console to view org hierarchy
- **user email** email for the principal (e.g joe.blogs@nibsc.org) 
- **share project** name of project that contains resources that are shared with other projects (e.g images for instance template creation)
- **host project** (*Optional*) Specify name of host project to connect the new project and use a shared VPC setup. This can be left empty if you wish to create a standalone project, although you will need to manually configure the firewall rules (edit `create-firewall-rules.sh` script)

```
# run script with shared VPC set-up
bash gcp_setup_main.sh 'jblogs' '123456789012' 'joe.blogs@xxx.org' 'share-proj-id' 'host-prj-id'
```


**Important!**

After running script, you must enable external IP addresses for the VMs in the project to run certain workflows. This requires changing one of the organisation policies for the project

To enable VMs with external IP address:
1. Select the project
2. Go to IAM & Admin -> Organisation Policies. 
3. Search for 'Define allowed external IPs for VM instances'. 
4. Edit the policy -> create a custom policy -> Select Allow All
5. Select Done and save


**Note on workflow modifications**

The script is modular by design, so it is relatively easy to edit and run any of the processes called by `gcp_setup_main.sh`. 

It is also possible to turn on/off different processes to alter the workflow by editing the following section in `gcp_setup_main.sh`. 
Edit the workflow section of the script and hash out any processes you don't want to run (or you can create new ones!)

```
#------------------------------------------------------------------------------
# Workflow
#------------------------------------------------------------------------------


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
If you would like to run any of these processes on a previously created project, you will just need to specify the `$project_name` variable in the this section of the `gcp_setup_main.sh` script just before the workflow section above:

```
#Note: to implement any of these scripts for an available project, just name the project and uncomment the 3 lines below

project_name='xxx-xxx-xxx-xxxx' # <- input project name
project_name=$(echo $project_name | sed 's/-/_/g')
export project_name
```