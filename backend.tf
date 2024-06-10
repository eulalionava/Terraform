terraform {
  backend "azurerm" {
    storage_account_name = "terrafomstatestorage"
    resource_group_name  = "Terraform"
    container_name       = "estadoterraform"
  }
}