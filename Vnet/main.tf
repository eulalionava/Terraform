resource "azurerm_virtual_network" "hub" {
  name                = "vnw-hub-pef-prd-eastus-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.20.0.0/24"]
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
resource "azurerm_virtual_network" "devops" {
  name                = "vnw-devops-prd-eastus-001"
  location            = var.location
  resource_group_name = var.resource_group_name_ntw
  address_space       = ["10.50.0.0/24"]
}

####subnets####

resource "azurerm_subnet" "subnet" {
  name                 = "snet-k8s-pef-prd-eastus-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.k8.name
  address_prefixes     = ["10.140.32.0/24"]
}
resource "azurerm_subnet" "subnet-aks" {
  name                 = "snet-k8s-pef-prd-eastus-002"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.k8.name
  address_prefixes     = ["10.140.0.0/21"]
}
resource "azurerm_subnet" "subnet-devops0" {
  name                 = "snet-devops-pef-ntw-eastus-001"
  resource_group_name  = var.resource_group_name_ntw
  virtual_network_name = azurerm_virtual_network.devops.name
  address_prefixes     = ["10.50.0.0/28"]
}
resource "azurerm_subnet" "subnet-devops1" {
  name                 = "snet-pe-pef-ntw-eastus-001"
  resource_group_name  = var.resource_group_name_ntw
  virtual_network_name = azurerm_virtual_network.devops.name
  address_prefixes     = ["10.50.0.32/27"]
}

resource "azurerm_subnet" "subnet-azurebastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.20.0.64/26"]
}

