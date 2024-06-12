resource "azurerm_resource_group" "rg_hub" {
  name     = "rsg-pef-hub2-prd-${var.location}-001"
  location = var.location
}
resource "azurerm_resource_group" "rg_pef" {
  name     = "rsg-pef-apm-prd-${var.location}-001"
  location = var.location
}
resource "azurerm_resource_group" "rg_aks" {
  name     = "rsg-pef-k8s-prd-${var.location}-001"
  location = var.location
}
resource "azurerm_resource_group" "rg_cdn" {
  name     = "rsg-pef-k8s-cdn-prd-${var.location}-001"
  location = var.location
}
resource "azurerm_resource_group" "rg_ntw" {
  name     = "rsg-pef-k8s-ntw-prd-${var.location}-001"
  location = var.location
}