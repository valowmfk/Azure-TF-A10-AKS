resource "azurerm_virtual_machine" "vthunder" {
    name                                  = "${var.project}-ADC"
    location                              = var.location
    resource_group_name                   = azurerm_resource_group.rg.name
    network_interface_ids                 = [azurerm_network_interface.vth-mgmt.id, azurerm_network_interface.vth-public-nic.id, azurerm_network_interface.vth-private-nic.id]
    primary_network_interface_id          = azurerm_network_interface.vth-mgmt.id
    vm_size                               = "Standard_D8s_v3"
    delete_data_disks_on_termination      = true
    
    plan {
      name                                = "vthunder-adc-521-byol"
      product                             = "a10-vthunder-adc-521"
      publisher                           = "a10networks"
    }
    
    storage_image_reference { 
        publisher                         = "a10networks"
        offer                             = "a10-vthunder-adc-521"
        sku                               = "vthunder-adc-521-byol"
        version                           = "5.2.16"
    }

    storage_os_disk { 
        name                              = "vthdisk1"
        caching                           = "ReadWrite"
        create_option                     = "FromImage"
        managed_disk_type                 = "Premium_LRS"
    }
    
    os_profile {
      computer_name                       = "${var.project}-ADC"
      admin_username                      = var.vth_admin_user
      admin_password                      = var.vth_admin_pass

    }
    os_profile_linux_config {
    disable_password_authentication = false
  }
    tags = {
        environment                       = "demo"
  }
}