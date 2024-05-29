resource "azurerm_container_registry" "acr" {
  name                = "crpefprd${var.location}client_number-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
  
}