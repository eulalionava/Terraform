resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "aks-subnet"
    address_prefix = "10.0.3.0/24"
  }
}