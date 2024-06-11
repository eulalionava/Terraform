resource "azurerm_container_registry" "acr" {
  name                = "crpefprd${var.location}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = true
  public_network_access_enabled = false
  
  
}