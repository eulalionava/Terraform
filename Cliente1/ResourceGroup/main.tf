resource "azurerm_resource_group" "example" {
  name     = "rsg-pef-hub-prd-${var.location}-001"
  location = var.location
}