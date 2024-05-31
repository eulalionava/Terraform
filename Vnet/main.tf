resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.virtual_network_name
  address_prefixes     = ["10.1.3.0/24"]
}