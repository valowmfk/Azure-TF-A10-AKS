#
# Terraform state backend
#
terraform {
  required_version = ">= 0.12"
  
  backend "azurerm" {
    resource_group_name  = "####"
    storage_account_name = "####"
    container_name       = "####"
    key                  = "####"
  }
}
#
# Get and pass SSH keys from Azure Key Vault to VMs
#
# Get existing Key Vault
data "azurerm_key_vault" "kv" {
  name                = "####"
  resource_group_name = "####"
}
# # Get existing Key
data "azurerm_key_vault_key" "ssh_key" {
  name         = "####"
  key_vault_id = data.azurerm_key_vault.kv.id
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
    admin_username = "ubuntu"

    ssh_key {
      key_data = data.azurerm_key_vault_key.ssh_key.public_key_openssh
    }
  }

  default_node_pool {
    name                  = "k8pool"
    node_count            = var.system_node_count
    vm_size               = "standard_DS2_v2"
    vnet_subnet_id        = azurerm_subnet.public[0].id
    type                  = "VirtualMachineScaleSets"
    enable_auto_scaling   = false
    orchestrator_version  = var.kubernetes_version
  }

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    load_balancer_sku   = "standard"
    network_plugin      = "kubenet"
    service_cidr        = "10.0.101.0/24"
    dns_service_ip      = "10.0.101.53"
  }
}