resource "azurerm_resource_group" "rg-hub" {
  name     = "rsg-pef-hub-prd-${var.location}client_number-001"
  location = var.location
}
resource "azurerm_resource_group" "example" {
  name     = "rsg-pef-apm-prd-${var.location}client_number-001"
  location = var.location
}
resource "azurerm_resource_group" "rg-aks" {
  name     = "rsg-pef-k8s-prd-${var.location}client_number-001"
  location = var.location
}