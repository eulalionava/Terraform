resource "azurerm_servicebus_namespace" "servicebus" {
  name                = "sbns-pef-prd-eastus-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

}