resource "azurerm_virtual_network" "global" {
  name                = "global"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.120.0.0/24"]
}
resource "azurerm_virtual_network" "Api" {
  name                = "api"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.130.0.0/24"]
}
resource "azurerm_virtual_network" "k8" {
  name                = "vnw-k8s-prd-eastus-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.140.0.0/16"]
}

####subnets####

resource "azurerm_subnet" "subnet" {
  name                 = "snet-k8s-pef-prd-eastus-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.k8.name
  address_prefixes     = ["10.140.1.0/24"]
}
resource "azurerm_subnet" "subnet-aks" {
  name                 = "snet-k8s-pef-prd-eastus-002"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.k8.name
  address_prefixes     = ["10.140.0.0/19"]
}
