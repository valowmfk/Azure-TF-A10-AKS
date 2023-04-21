# Define Terraform provider
terraform {
  required_version = ">= 0.12"
    # backend "local" {
      
    # }
  backend "azurerm" {
    resource_group_name  = "a10se-prod-rg"
    storage_account_name = "a10setfhdd"
    container_name       = "core-tfstate"
    key                  = "core.secloud.tfstate"
  }
}
# Configure the Azure provider
provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }
  }
}

