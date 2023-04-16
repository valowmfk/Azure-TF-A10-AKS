# Azure-TF-A10-AKS
Terraform Deployment for A10 vThunder and AKS

Within the remote_backend directory is a terraform to create your backend terraform state storage, accounts, etc. Azure will become your state table reference for terraform, no longer local.
*** IMPORTANT ***
Once you're migrated your terraform init over to the new backend state, be cautious as TF will attempt to delete the resource_group and items within as it might not have a fully synced state. You can resolve this by using terraform state rm to remove the individual missing items from the backend state.
