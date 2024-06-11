resource "azurerm_subnet" "global" {
  name                = "SubnetGlobal1"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.120.0.0/24"]
}