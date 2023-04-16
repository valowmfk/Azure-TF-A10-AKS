#
#Here we build the Azure resource group
#
resource "azurerm_resource_group" "rg" {
  name        = "A10CloudDemoRG"
  location    = var.location
}
#
# Build Azure Virtual Network with CIDR Variable (10.0.0.0/8)
#
resource "azurerm_virtual_network" "vnet" {
  name                    = "A10CloudDemoVNet"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  address_space           = ["10.0.0.0/8"]
#   depends_on = [
#     azurerm_resource_group.resource_group.azurerm_resource_group.rg.name
#   ]
}
#
# Create Subnets
#
resource "azurerm_subnet" "mgmt" {
name                    = "mgmt"
resource_group_name     = azurerm_resource_group.rg.name
virtual_network_name    = azurerm_virtual_network.vnet.name
address_prefixes        = ["10.0.251.0/24"]
}

resource "azurerm_subnet" "public" {
  count                   = var.azs
  name                    = "public"
  resource_group_name     = azurerm_resource_group.rg.name
  address_prefixes        = ["10.0.${11 + count.index}.0/24"]
  # address_prefixes        = ["10.0.11.0/24"]
  virtual_network_name    = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "private" {
  count = var.azs
  name                    = "private"
  resource_group_name     = azurerm_resource_group.rg.name
  address_prefixes        = ["10.0.${101 + count.index}.0/24"]
  # address_prefixes      = ["10.0.101.0/24"]
  virtual_network_name    = azurerm_virtual_network.vnet.name
}

#
# Create Public IPs where needed
#
resource "azurerm_public_ip" "mgmt" { 
  name                  = "mgmt-public-ip"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  allocation_method     = "Static"
}

resource "azurerm_public_ip" "vip" { 
  name                  = "vip-public-ip"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  allocation_method     = "Static"
}

#
# Create NICs
#
resource "azurerm_network_interface" "vth-mgmt" {
    name                = "vth-mgmt-nic"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
      name                          = "mgmt-nic"
      subnet_id                     = azurerm_subnet.mgmt.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = azurerm_public_ip.mgmt.id
    }   
}

resource "azurerm_network_interface" "vth-public-nic" {
    name                = "vth-public-nic"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    enable_accelerated_networking = true

    ip_configuration {
      name                          = "public-nic"
      subnet_id                     = azurerm_subnet.public[0].id
      private_ip_address_allocation = "Dynamic"
    }   
}

resource "azurerm_network_interface" "vth-private-nic" {
    name                = "vth-private-nic"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    enable_accelerated_networking = true

    ip_configuration {
      name                          = "private-nic"
      subnet_id                     = azurerm_subnet.private[0].id
      private_ip_address_allocation = "Dynamic"
    }   
}

#
# Create NAT Gateway
#
resource "azurerm_public_ip" "ngw-publicip" {
  name                = "nat-gateway-publicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
#   zones               = ["1"]
}

resource "azurerm_public_ip_prefix" "ngw-publicprefix" {
  name                = "nat-gateway-publicIPPrefix"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 30
#   zones               = ["1"]
}
resource "azurerm_nat_gateway" "ngw" {
  name                    = "nat-Gateway"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
#   zones                   = ["1"]
}

#
# Create Route Tables and attach routes
#
resource "azurerm_route_table" "main" {
  name                          = "main-rt"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = true
  
  route { 
    name = "default"
    address_prefix  = "0.0.0.0/0"
    # next_hop_type   = azurerm_virtual_network.vnet.name
    next_hop_type = "VnetLocal"
  }
  tags = {
    name = "${var.project}-Default-rt"
  }
}
# resource "azurerm_route" "main" {
#   name                  = "main-route"
#   resource_group_name   = azurerm_resource_group.rg.name
#   route_table_name      = azurerm_route_table.main.name
#   address_prefix        = "0.0.0.0/0"
#   # next_hop_type         = azurerm_virtual_network.vnet.name
#   next_hop_type = "VnetLocal"
# }

#
# Create and Associate Network Security Groups
#
resource "azurerm_network_security_group" "public_nsg" {
  name                = "${var.project}-Public-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet_network_security_group_association" "public_nsg-associate" {
  depends_on = [azurerm_network_security_rule.web_nsg_rule_inbound]
  subnet_id = azurerm_subnet.mgmt.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}
    locals {
      web_inbound_ports_map = {
        "100" : "80"
        "110" : "443"
        "120" : "22"
      }
    }
resource "azurerm_network_security_rule" "web_nsg_rule_inbound" {
  for_each                    = local.web_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.public_nsg.name
}