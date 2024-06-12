resource "azurerm_servicebus_namespace" "servicebus" {
  name                = "sbns-pef-prd-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}