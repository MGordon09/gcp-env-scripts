#!/bin/bash

#linking new project with the MHRA billing account
gcloud billing projects link $project_name \
    --billing-account $billing_account_id