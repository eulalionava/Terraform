resource "azuread_application" "app" {
  display_name               = "appcs-pef-prd-eastus-001"
  identifier_uris            = var.identifier_uris
  available_to_other_tenants = false
}

resource "azuread_service_principal" "app" {
  application_id = azuread_application.app.application_id
}

resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.app.id
  value                = var.client_secret
  end_date             = var.client_secret_end_date
}