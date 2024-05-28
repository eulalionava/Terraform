resource "azurerm_resource_group" "example" {
  name     = var.client_name
  location = var.location
}