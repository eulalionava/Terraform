resource "azurerm_resource_group" "VNET-RG" {
  name     = "VNET-RG"
  location = var.location
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.VNET-RG.location
  resource_group_name = azurerm_resource_group.VNET-RG.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.VNET-RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}