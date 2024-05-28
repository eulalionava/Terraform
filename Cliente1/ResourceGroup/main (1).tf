resource "azurerm_resource_group" "example" {
  name     = "${var.client_name}RG"
  location = var.location
}