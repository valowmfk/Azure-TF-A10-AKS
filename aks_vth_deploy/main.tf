#
# Terraform state backend
#
terraform {
  required_version       = ">= 0.12"
 #
 # For the below to work, you will need to create a storage account and container/key to store your terraform states
 # If you do not need this, you can comment this section out.
 # If your team is using terraform in an environment from multiple sources, this is highly recommended
 #
  backend "azurerm" {
    resource_group_name  = "<your values here>"
    storage_account_name = "<your values here>"
    container_name       = "<your values here>"
    key                  = "<your values here>"
  }
}
#
# Get and pass SSH keys from Azure Key Vault to VMs
#
# Get existing Key Vault
data "azurerm_key_vault" "kv" {
  name                = "<your values here>"
  resource_group_name = "<your values here>"
}
# # Get existing Key
data "azurerm_key_vault_key" "ssh_key" {
  name                = "<your values here>"
  key_vault_id        = data.azurerm_key_vault.kv.id
}

#
# Prevent a10se-prod-rg Deletion
#

#
# Azure AKS Creation
#
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.cluster_name}-aks"
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  node_resource_group = "${var.node_resource_group}-node-rg"

  linux_profile {
    admin_username  = "ubuntu"

    ssh_key {
      key_data      = data.azurerm_key_vault_key.ssh_key.public_key_openssh
    }
  }

  default_node_pool {
    name                  = "k8pool"
    node_count            = var.system_node_count
    vm_size               = "standard_DS2_v2"
    vnet_subnet_id        = azurerm_subnet.public.id
    type                  = "VirtualMachineScaleSets"
    enable_auto_scaling   = false
    orchestrator_version  = var.kubernetes_version
  }

  network_profile {
    load_balancer_sku   = "standard"
    network_plugin      = "kubenet"
    network_profile     = "calico"
    service_cidr        = "10.0.105.0/24"
    dns_service_ip      = "10.0.105.53"
  }
  service_principal {
    client_id                       = var.aks_service_principal_app_id
    client_secret                   = var.aks_service_principal_client_secret
  }
  role_based_access_control_enabled = true
}