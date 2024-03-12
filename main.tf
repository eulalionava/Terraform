resource "azurerm_resource_group" "VNET-RG" {
  name     = "VNET-RG"
  location = var.location
}