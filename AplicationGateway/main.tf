resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip"
  resource_group_name = azurerm_resource_group.natus-seg-rg.name
  location            = azurerm_resource_group.natus-seg-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw01"
  resource_group_name = azurerm_resource_group.natus-seg-rg.name
  location            = azurerm_resource_group.natus-seg-rg.location

  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }

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
    name                 = "my_frontend_ip_configuration"
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