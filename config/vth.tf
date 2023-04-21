#
#  vThunder configs for A10 Cloud Demo
#  Matt Klouda, John Allen, Anders DuPuis-Lund, Jim McGhee
#  Updated provider to version 1.2.0
#

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
    linux = {
      source = "mavidser/linux"
      version = ">=1.0.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.19"
    }
  }
}

provider "thunder" {
  address  = var.vth_mgmt_ip
  username = var.vth_admin_user
  password = var.vth_admin_pass
}
resource "thunder_ip_dns_primary" "dns1" {
  ip_v4_addr = "8.8.8.8"
}
resource "thunder_virtual_server" "ws-vip" {
  name = "ws-vip"
  ip_address = var.thunder_vip
  port_list {
    port_number = 80
    protocol = "tcp"
  }
}
#
# Add GLM config and token - Update with your GLM token for vThunder
#
resource "thunder_glm" "glm1" {
  use_mgmt_port   = 1
  enable_requests = 1
  token           = "####"
   depends_on = [
    thunder_ip_dns_primary.dns1
  ]
}
#
# Send GLM 
#
resource "thunder_glm_send" "glm1" {
  license_request = 1
  depends_on = [
    thunder_glm.glm1
  ]
}
#
# Configure ethernet interfaces and name/description
#
resource "thunder_interface_ethernet" "eth1" {
  ifnum  = 1
  name   = "Eth1_Servers_Public_Inside"
  action = "enable"
  ip {
    address_list {
      # ipv4_address = "10.0.11.11"
      ipv4_address = var.vth_public_ip
      ipv4_netmask = "/24"
    }
  }
}
resource "thunder_interface_ethernet" "eth2" {
  ifnum  = 2
  name   = "Eth2_Servers_VIP_Private_Outside"
  action = "enable"
  ip {
    address_list {
      ipv4_address = "10.0.101.4"
      ipv4_netmask = "/24"
    }
  }
}
