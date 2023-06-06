# Infrastructure with Terraform

## How to apply infrastructure changes

1. [Install terraform 1.4.0](https://releases.hashicorp.com/terraform/1.4.0/)

2. [Install azure cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

3. Login to azure using azure cli

   `export ARM_CLIENT_ID=REPLACE WITH APPLICATION_ID OF SP`
   `export ARM_CLIENT_SECRET=REPLACE CLIENT SECRET FROM KV`
   `export ARM_SUBSCRIPTION_ID=REPLACE WITH SUBSCRIPTION ID`
   `export ARM_TENANT_ID=REPLACE WITH TENANT ID`

   `az login --service-principal -u <APPLICATION_ID> -p <SECRET>--tenant <TENANT_ID>`

4. Change your directory to environment specific Ex - `Infrastructure/terraform/env/dev`, the following commands only work when run in this directory

5. Use `init.sh` to set the environment (kpimpapidev, kpimpapitest, kpimpapiprod) you want to work with

   `source ./init.sh kpimpapidev`

6. Use terraform to plan & apply the infrastructure

   ```
   terraform plan  -out <UNIQUE_NAME> eg. =  terraform plan -out change1.tfplan
   terraform apply  "<PLAN File Name>" eg. =  terraform apply "change1.tfplan"
   ```
