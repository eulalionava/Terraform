#AKS RG
resource "azurerm_resource_group" "example" {
  name     = "rsg-pef-k8s-prd-${var.location}client_number-001"
  location = var.location
}