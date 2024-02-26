resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = var.location
}
resource "azurerm_container_registry" "acr" {
  name                  = "AcrTestlabs"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  sku                   = "Basic"
  data_endpoint_enabled = true
}
