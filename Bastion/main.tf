resource "azurerm_public_ip" "ip" {
  name                = "pe-stpefprdeastus-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = "bas-pef-prd-eastus-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            =  var.vnet_subnet_id
    public_ip_address_id = azurerm_public_ip.ip.id
  }
}