##########################################################################
# RESOURCES & MODULES
##########################################################################

module "vmss-lb" {
  source              = "Azure/loadbalancer/azurerm"
  resource_group_name = azurerm_resource_group.lab-RG1.name
  name                = "vmss-lb"
  frontend_name       = "pip-vmss-lb"
  pip_name            = "pip-vmss-lb"
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
 resource_group_name = azurerm_resource_group.lab-RG1.name
 loadbalancer_id     = module.vmss-lb.azurerm_lb_id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss-probe" {
 resource_group_name = azurerm_resource_group.lab-RG1.name
 loadbalancer_id     = module.vmss-lb.azurerm_lb_id
 name                = "http-running-probe"
 port                = "5000"
}

resource "azurerm_lb_rule" "lbnatrule" {
   resource_group_name            = azurerm_resource_group.lab-RG1.name
   loadbalancer_id                = module.vmss-lb.azurerm_lb_id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = "5000"
   backend_port                   = "5000"
   backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
   frontend_ip_configuration_name = "pip-vmss-lb"
   probe_id                       = azurerm_lb_probe.vmss-probe.id
}

resource "azurerm_lb_nat_rule" "lb-nat-rule" {
  resource_group_name            = azurerm_resource_group.lab-RG1.name
  loadbalancer_id                = module.vmss-lb.azurerm_lb_id
  name                           = "SSHAccess"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "pip-vmss-lb"
}