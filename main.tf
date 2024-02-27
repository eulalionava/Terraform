data "azurerm_resource_group" "rg" {
  name = var.rg
}

output "id" {
  value = "/subscriptions/e9cdf5ea-1d5c-48c0-b179-7dc7a4973f06/resourceGroups/RG-TESTLABS-RM"
}
resource "azurerm_container_registry" "acr" {
  name                  = "AcrTestlabs"
  resource_group_name   = "RG-TESTLABS-RM"
  location              = var.location
  sku                   = "Basic"
  data_endpoint_enabled = false

  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
  }
}
