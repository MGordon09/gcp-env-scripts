#!/bin/bash

#linking new project with the MHRA billing account

# reset seperators to '-'
project_name=$(reset_var $project_name)
billing_account_id=$(reset_var $billing_account_id)

gcloud beta billing projects link $project_name \
    --billing-account $billing_account_id