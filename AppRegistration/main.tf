resource "azuread_application" "example" {
  name                       = var.app_name
  homepage                   = var.homepage
  identifier_uris            = var.identifier_uris
  reply_urls                 = var.reply_urls
  available_to_other_tenants = false
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}

resource "azuread_service_principal_password" "example" {
  service_principal_id = azuread_service_principal.example.id
  value                = var.client_secret
  end_date             = var.client_secret_end_date
}