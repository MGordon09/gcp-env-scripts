#!/bin/bash

# base set of filewall rules for projects not connect to host VPC
# as default only allow connection to VMs in project

#allow ssh to VM using IAP
gcloud compute firewall-rules create fw-allow-ssh-from-iap-to-vm \
    --description="Ingress firewall rule to allow ssh into VM using IAP" \
    --direction=INGRESS --priority=1000 --action=ALLOW --rules=tcp:22 \
    --network=${project_name}-network \
    --source-ranges="35.235.240.0/20" --enable-logging