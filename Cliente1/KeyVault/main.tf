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
      "create",
      "delete",
      "get",
      "list",
      "update",
      "import",
      "backup",
      "restore",
    ]

    secret_permissions = [
      "delete",
      "get",
      "list",
      "set",
    ]

    storage_permissions = [
       "delete",
      "deletesas",
      "get",
      "getsas",
      "list",
      "listsas",
      "regeneratekey",
      "set",
      "setsas",
      "update",
    ]
    certificate_permissions = [
      "delete",
      "get",
      "list",
      "create",
      "import",
      "update",
      "managecontacts",
      "getissuers",
      "listissuers",
      "setissuers",
      "deleteissuers",
      "manageissuers",
    ]
  }
}