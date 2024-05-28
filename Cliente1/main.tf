resource "azurerm_resource_group" "example" {
  name     = "${client_name}-RG"
  location = var.location
}