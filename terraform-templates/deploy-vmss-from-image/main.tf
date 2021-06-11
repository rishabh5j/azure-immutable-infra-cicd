##########################################################################
# VARIABLES
##########################################################################


##########################################################################
# RESOURCES & MODULES
##########################################################################

resource "azurerm_resource_group" "lab-RG1" {
  name = "lab-RG1"
  location = "East US"
  tags = {
      environment = "prod"
    }
}

resource "azurerm_virtual_machine_scale_set" "website-vmss" {
  name                = "website-vmss"
  resource_group_name = azurerm_resource_group.lab-RG1.name
  location            = azurerm_resource_group.lab-RG1.location
  sku                 {
    name =  "Standard_B2s"
    tier = "Standard"
    capacity = 1
  }
  upgrade_policy_mode = "Manual"
  storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_image_reference {
   id = "/subscriptions/${var.subscription_id}/resourceGroups/lab-RG/providers/Microsoft.Compute/images/vm-packer-image"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

  os_profile {
  computer_name_prefix = "vmlab"
  admin_username      = var.username
  admin_password      = var.password
  custom_data          = file("web.conf")
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

  network_profile {
    name    = "nic1"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.subnet1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
    }
    network_security_group_id = azurerm_network_security_group.nsg-subnet1.id
  }
}

##########################################################################
# PROVIDERS
##########################################################################
provider "azurerm" {
  features {}
}

##########################################################################
# OUTPUTS
##########################################################################

output "vnet-id"{
    value = azurerm_virtual_network.vnet-lab1.id
}