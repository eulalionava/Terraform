resource "azurerm_key_vault" "keyvault" {
  name                        = "kvt-pef-prd-${var.location}-001"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}