##########################################################################
# RESOURCES & MODULES
##########################################################################

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.lab-RG1.name
  virtual_network_name = azurerm_virtual_network.vnet-lab1.name
  address_prefixes     = ["10.0.0.0/24"]
  }

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.lab-RG1.name
  virtual_network_name = azurerm_virtual_network.vnet-lab1.name
  address_prefixes     = ["10.0.1.0/24"]
  }

  resource "azurerm_network_security_group" "nsg-subnet1" {
  name                = "nsg-subnet1"
  location            = azurerm_resource_group.lab-RG1.location
  resource_group_name = azurerm_resource_group.lab-RG1.name

  security_rule {
    name                       = "inbound-tcp-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-subnet1-association" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg-subnet1.id
}

resource "azurerm_virtual_network" "vnet-lab1" {
  name                = "vnet-lab2"
  location            = azurerm_resource_group.lab-RG1.location
  resource_group_name = azurerm_resource_group.lab-RG1.name
  address_space       = ["10.0.0.0/16"]
}