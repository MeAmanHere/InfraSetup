#!/bin/bash
# Terraform init script, source this in your shell to set it up for terraform.
WORKSPACE="kpimpapidev"
RESOURCE_GROUP_NAME=""
STORAGE_ACCOUNT_NAME=""
SUBSCRIPTION_NAME=""
SUBSCRIPTION=$(az account show --query 'id' --output tsv --subscription "$SUBSCRIPTION_NAME")
echo "Activating subscription: $SUBSCRIPTION ($SUBSCRIPTION_NAME)"
az account set --subscription $SUBSCRIPTION
STORAGE_ACCOUNT_KEY=$(az storage account keys list --account-name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME --subscription $SUBSCRIPTION --query "[?keyName=='key1'].value" --output tsv)

echo "Initializing terraform"
terraform init -upgrade -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" -backend-config="access_key=$STORAGE_ACCOUNT_KEY"

TF_WORKSPACES=$(terraform workspace list)
if [[ $TF_WORKSPACES =~ $WORKSPACE ]]
then
  echo "Switching to workspace ${WORKSPACE}"
  terraform workspace select $WORKSPACE
else
  echo "Workspace ${WORKSPACE} does not yet exist, creating..."
  terraform workspace new $WORKSPACE
fi

export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION
