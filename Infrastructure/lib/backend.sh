#!/bin/bash
echo "##[group]Terraform init backend"
echo "##[debug] Initialise terraform backend script started"
set -eu # fail on error
# Variables for terraform backend
LOC=$terraformBackendLocation
RG=$terraformBackendResourceGroup
SA=$terraformBackendStorageAccount
SUB_ID=
export AZURE_STORAGE_ACCOUNT=$terraformBackendStorageAccount
BC=$terraformBackendStorageContainer
# set correct subscription id
az account set -s $subscription_id
export AZURE_STORAGE_KEY="$(az storage account keys list -g "$RG" -n "$SA" --query '[0].value' -o tsv)"
BLOB=$terraformRemoteStateFile
# export TERRAFORM_BREAK_LEASE=1
echo "##[debug] Variables have been set"
if test -z "$AZURE_STORAGE_KEY"; then
    az group create --location "$LOC" --resource-group "$RG"
    az configure --defaults group="$RG" location="$LOC"
    az storage account create -n "$SA" -o none
    # there is an issue here because we need for Azure to provision storage account before proceeding
    # rerunning pipeline fixes this but not very smart code
    az storage account blob-service-properties update --enable-delete-retention true --delete-retention-days 100 -n "$SA" -o none
    az storage account blob-service-properties update --enable-versioning -n "$SA" -o none
    export AZURE_STORAGE_KEY="$(az storage account keys list -g "$RG" -n "$SA" --query '[0].value' -o tsv)"
fi
echo "##[debug] AZURE_STORAGE_KEY env variable is set"
if ! az storage container show -n "$BC" -o none 2>/dev/null; then
    az storage container create -n "$BC" -o none
fi
echo "##[debug] Storage account created: $SA"
if [[ $(az storage blob exists -c "$BC" -n "$BLOB" --query exists) = "true" ]]; then
    if [[ $(az storage blob show -c "$BC" -n "$BLOB" --query "properties.lease.status=='locked'") = "true" ]]; then
        echo "##[debug] Remote state file is leased"
        lock_jwt=$(az storage blob show -c "$BC" -n "$BLOB" --query metadata.terraformlockid -o tsv)
        if [ "$lock_jwt" != "" ]; then
            lock_json=$(base64 -d <<<"$lock_jwt")
            echo "##[debug] Remote state file ($BLOB) has been locked"
            jq . <<<"$lock_json"
        fi
        if [ "${TERRAFORM_BREAK_LEASE:-}" != "" ]; then
            az storage blob lease break -c "$BC" -b "$BLOB"
        else
            echo "##[debug] If you're really sure you want to break the lease, rerun the pipeline with variable TERRAFORM_BREAK_LEASE set to 1."
            exit 1
        fi
    fi
fi
echo "##[endgroup]"
