#Grupo de recursos para las vnet
#resource "azurerm_resource_group" "VNET-RG" {
#  name     = "VNET-RG"
#  location = var.location
data "azurerm_resource_group" "VNET-RG" {
  name = "VNET-RG"
}

output "id2" {
  value = "/subscriptions/e9cdf5ea-1d5c-48c0-b179-7dc7a4973f06/resourceGroups/VNET-RG"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = "VNET-RG"
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet01"
  resource_group_name  = "VNET-RG"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#Grupo de recursos para el application gateway
#resource "azurerm_resource_group" "natus-seg-rg" {
#  name     = "natus-seg-rg"
#  location = var.location
#  tags = {
#    Environment = "Natus"
#    Department  = "EH"
#    Createdby   = "Terraform"
#    EmailOwner  = "acardenas@readymind.ms"
#  }
#}
data "azurerm_resource_group" "natus-seg-rg" {
  name = "natus-seg-rg"
}

output "id3" {
  value = "/subscriptions/e9cdf5ea-1d5c-48c0-b179-7dc7a4973f06/resourceGroups/natus-seg-rg"
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip"
  resource_group_name = "natus-seg-rg"
  location            = var.location
  allocation_method   = "Static"
}

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet.name}-rdrcfg"
}
resource "azurerm_application_gateway" "appgw01" {
  name                = "appgw01"
  resource_group_name = "natus-seg-rg"
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
    public_ip_address_id = azurerm_public_ip.public_ip.id
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
}
#Grupo de recursos para aks
#resource "azurerm_resource_group" "natus-aks" {
#  name     = "natus-aks"
#  location = var.location
#  tags = {
#    Environment = "Natus"
#    Department  = "EH"
#    Createdby   = "Terraform"
#    EmailOwner  = "acardenas@readymind.ms"
#  }
#}

data "azurerm_resource_group" "natus-aks" {
  name = "natus-aks"
}

output "id4" {
  value = "/subscriptions/e9cdf5ea-1d5c-48c0-b179-7dc7a4973f06/resourceGroups/natus-aks"
}
resource "azurerm_container_registry" "acr01" {
  name                = "containerRegistry01"
  resource_group_name = "natus-aks"
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false
  
  
}

#AKS
resource "azurerm_kubernetes_cluster" "aks01" {
  name                = "aks1"
  location            = var.location
  resource_group_name = "natus-aks"
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"

    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }
  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    network_plugin = "azure"
  }
  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks01.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks01.kube_config_raw

  sensitive = true
}
