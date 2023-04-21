# Azure-TF-A10-AKS

vThunder configs for A10 Cloud Demo
Matt Klouda, John Allen, Anders DuPuis-Lund, Jim McGhee
Updated thunder provider to version 1.2.1

Terraform Deployment for A10 vThunder and AKS

Azure CLI, Terraform and kubectl are prerequisites to complete this deployment.

The remote_backend directory is a terraform to create your backend terraform state storage, accounts, etc. This is recommended for teams that are running terraform against your environment from multiple sources.

Key values have been replaced with -your values here-

Azure CLI configuration prerequisists must be met. Once the environment is deployed (AKS and vThunder) you'll need to run this command:
az aks get-credentials --resource-group !!!name!!! --name !!!name!!! --admin

The above command will give you the correct permissions for kubectl.

Please contact seclouddemo@a10networks.com with any questions.
