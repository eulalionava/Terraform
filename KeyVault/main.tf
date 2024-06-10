resource "azurerm_key_vault" "keyvault" {
  name                        = "kvt-pef-prd-${var.location}-002"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant
    object_id = var.key_vault_manager

    key_permissions = [
      "Create",
      "Delete",
      "Get",
      "List",
      "Update",
      "Import",
      "Backup",
      "Restore",
    ]

    secret_permissions = [
      "Delete",
      "Get",
      "List",
      "Set",
    ]

    storage_permissions = [
      "Delete",
      "DeleteSAS",
      "Get",
      "GetSAS",
      "List",
      "ListSAS",
      "RegenerateKey",
      "Set",
      "SetSAS",
      "Update",
    ]
    certificate_permissions = [
      "Delete",
      "Get",
      "List",
      "Create",
      "Import",
      "Update",
      "ManageContacts",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "ManageIssuers",
    ]
  }
}