#!/bin/bash
echo "##[group]Initialise terraform"
echo "##[debug]  Terraform init script started"
set -eux  # fail on error

# if  [ ! -z ${TERRAFORM_WORKDIR:=""} ]; then
#  cd ${terraformWorkingDir}
# fi

terraform init \
    -upgrade \
    -backend-config=resource_group_name=${terraformBackendResourceGroup} \
    -backend-config=storage_account_name=${terraformBackendStorageAccount} \
    -backend-config=container_name=${terraformBackendStorageContainer} \
    -backend-config=key=${terraformRemoteStateFile} \
    -backend-config=subscription_id=$subscription_id \
    -backend-config=tenant_id=$ARM_TENANT_ID \
    -backend-config=client_id=$ARM_CLIENT_ID \
    -backend-config=client_secret="$ARM_CLIENT_SECRET" \
    -no-color \
    -input=false
# if  [[ $terraformDestroy == True ]]; then
#   terraform destroy -auto-approve
#   terraform state list 
# fi
# echo "##[debug] Terraform init complete for build: ${BUILD_BUILDNUMBER}"

# terraform  plan -out="${BUILD_BUILDNUMBER}.tfplan" -no-color -input=false
# echo "##[debug] Terraform plan complete for build: ${BUILD_BUILDNUMBER}"

# [[ $terraformShowFlag == True ]] \
#   && 
#   terraform show -no-color ${BUILD_BUILDNUMBER}.tfplan
#   terraform show -no-color ${BUILD_BUILDNUMBER}.tfplan > tfplan.out
# echo "##[endgroup]"
