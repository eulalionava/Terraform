resource "azurerm_resource_group" "example" {
  name     = "rsg-pef-hub-prd-${var.location}client_number-001"
  location = var.location
}