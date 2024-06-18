resource "azuread_application" "app" {
  display_name               = "appcs-pef-prd-eastus-001"
  identifier_uris            = var.identifier_uris
  sign_in_audience           = var.sign_in_audience
  available_to_other_tenants = false

  web {
    home_page_url            = var.home_page_url
    redirect_uris            = var.redirect_uris
    logout_url               = var.logout_url

    implicit_grant {
      access_token_issuance_enabled = var.access_token_issuance_enabled
      id_token_issuance_enabled     = var.id_token_issuance_enabled
    }
  }

  required_resource_access {
    resource_app_id = var.resource_app_id

    resource_access {
      id   = var.resource_access_id
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "app" {
  application_id = azuread_application.app.application_id
}

resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.app.id
  value                = var.client_secret
  end_date             = var.client_secret_end_date
}