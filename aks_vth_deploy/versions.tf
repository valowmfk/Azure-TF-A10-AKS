terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }
    thunder = {
      source  = "a10networks/thunder"
      version = "1.2.1"
    }
  }
}

provider "azurerm" {
  features {

  resource_group {
    prevent_deletion_if_contains_resources = true
    }
  }
}