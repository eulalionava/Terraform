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

resource "azurerm_arc_kubernetes_cluster" "aks" {
  name                         = "AksTestlabs"
  resource_group_name          = var.rg
  location                     = var.location
  
  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "KvTestlabs"
  location                    = var.location
  resource_group_name         = var.rg
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "VnetTestLabs"
  resource_group_name = var.rg
  location            = var.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "SubnetTestlabs"
  resource_group_name  = var.rg
  virtual_network_name = var.location
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-pip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "GatewayTestlabs"
  resource_group_name = var.rg
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
  }
}
