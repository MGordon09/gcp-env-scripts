#!/bin/bash

# make ngs-tools & ngs-nextflow VM instance template

# reset seperators to '-'
project_name=$(reset_var $project_name)
prj_prefix=$(reset_var $prj_prefix)

host_prefix=$(echo "${host_prj}" | cut -d'-' -f'1-3')


create_instance_templates(){

    create_ngs_tools #create conda/singularity vm instance template
    create_ngs_nextflow #create nextflow/dsub vm instance template

}


create_ngs_tools(){
    gcloud compute instance-templates create mhra-ngs-tools-v3 \
        --project=$project_name \
        --description="'VM instance template for mhra-ngs-tools which consists of Conda and Singularity'" \
        --machine-type=n1-standard-2 \
        --network-interface=subnet=projects/$host_prj/regions/europe-west2/subnetworks/$host_prefix-eu-west2-1,no-address \
        --network-interface=subnet=$prj_prefix-eu-west2-1,no-address \
        --metadata=enable-oslogin=true \
        --maintenance-policy=MIGRATE \
        --provisioning-model=STANDARD \
        --service-account=ngs-tools-vm@$project_name.iam.gserviceaccount.com \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --region=europe-west2 \
        --tags=mhra-ngs-tools \
        --create-disk=auto-delete=yes,boot=yes,device-name=persistent-disk-0,image=projects/$shr_prj/global/images/mhra-ngs-tools-v2,mode=rw,size=20,type=pd-balanced \
        --no-shielded-secure-boot \
        --shielded-vtpm \
        --shielded-integrity-monitoring \
        --labels=vm-type=mhra-ngs-tools \
        --reservation-affinity=any
}


create_ngs_nextflow(){
    gcloud compute instance-templates create mhra-ngs-nextflow-dsub-v3 \
        --project=$project_name \
        --description="'VM instance template for Nextflow and Dsub with Docker container runtime pre-installed'" \
        --machine-type=e2-medium \
        --region=europe-west2 \
        --network-interface=subnet=projects/$host_prj/regions/europe-west2/subnetworks/$host_prefix-eu-west2-1,no-address \
        --network-interface=subnet=$prj_prefix-eu-west2-1,no-address \
        --metadata=enable-oslogin=true \
        --maintenance-policy=MIGRATE \
        --provisioning-model=STANDARD \
        --service-account=nextflow-vm@m$project_name.iam.gserviceaccount.com \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --tags=mhra-ngs-nextflow \
        --create-disk=auto-delete=yes,boot=yes,device-name=persistent-disk-0,image=projects/$shr_prj/global/images/mhra-ngs-nextflow-dsub-v2,mode=rw,size=10,type=pd-balanced \
        --no-shielded-secure-boot \
        --shielded-vtpm \
        --shielded-integrity-monitoring \
        --labels=vm-type=mhra-ngs-nextflow-dsub \
        --reservation-affinity=any
}

#run script
create_instance_templates