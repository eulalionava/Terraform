resource "azurerm_app_configuration" "appconfig" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
}

resource "azurerm_app_configuration_key" "appconfig" {
  for_each             = var.keys
  configuration_store_id = azurerm_app_configuration.appconfig.id
  key                 = each.key
  value               = each.value
  label               = each.label
  content_type        = each.content_type
  tags                = each.tags
}