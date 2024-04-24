#Grupo de recursos para las vnet
resource "azurerm_resource_group" "VNET-RG" {
  name     = "VNET-RG"
  location = var.location
  
  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.VNET-RG.location
  resource_group_name = azurerm_resource_group.VNET-RG.name

  
  ddos_protection_plan {
    enable = false
    id = "/subscriptions/12345678-90ab-cdef-1234-567890abcdef/resourceGroups/example-resources/providers/Microsoft.Network/ddosProtectionPlans/example-ddos-plan"
  }

  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.VNET-RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "subnet-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.VNET-RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_subnet" "subnet-agent" {
  name                 = "subnet-agent"
  resource_group_name  = azurerm_resource_group.VNET-RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}
resource "azurerm_subnet" "global" {
  name                                      = "snet-global"
  resource_group_name                       = azurerm_resource_group.VNET-RG.name
  virtual_network_name                      = azurerm_virtual_network.vnet.name
  address_prefixes                          = ["10.0.4.0/24"]
  private_endpoint_network_policies_enabled = true
}
#Grupo de recursos para el agente
resource "azurerm_resource_group" "natus-devops-int" {
  name     = "natus-devops-int"
  location = var.location
  
  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }
}
resource "azurerm_public_ip" "bas" {
  name                = "natus-bas01"
  location            = azurerm_resource_group.natus-devops-int.location
  resource_group_name = azurerm_resource_group.natus-devops-int.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_bastion_host" "bastion" {
  name                = "natus-bas"
  location            = azurerm_resource_group.natus-devops-int.location
  resource_group_name = azurerm_resource_group.natus-devops-int.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet-bastion.id
    public_ip_address_id = azurerm_public_ip.bas.id
  }
}
resource "azurerm_network_interface" "network-interface" {
  name                = "agent-nic"
  location            = azurerm_resource_group.natus-devops-int.location
  resource_group_name = azurerm_resource_group.natus-devops-int.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-agent.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "agent-azuredevops"
  resource_group_name = azurerm_resource_group.natus-devops-int.name
  location            = azurerm_resource_group.natus-devops-int.location
  size                = "Standard_F2"
  admin_username      = "natususer"
  admin_password      = "N4tu5!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.network-interface.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }  
}
#Grupo de recursos para el application gateway
resource "azurerm_resource_group" "natus-seg-rg" {
  name     = "natus-seg-rg"
  location = var.location

  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }
}

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

locals {
  backend_address_pool_name      = "${azurerm_virtual_network.vnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.vnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet.name}-rdrcfg"
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
resource "azurerm_resource_group" "natus-aks" {
  name     = "natus-aks"
  location = var.location

  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "acrnatus01"
  resource_group_name = azurerm_resource_group.natus-aks.name
  location            = azurerm_resource_group.natus-aks.location
  sku                 = "Premium"
  admin_enabled       = true
  public_network_access_enabled = false

  tags = {
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }  
  
}
resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.natus-aks.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr1" {
  name                  = "linkdnsacr01"
  resource_group_name   = azurerm_resource_group.natus-aks.name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
resource "azurerm_private_endpoint" "acr" {
  name                = "pe-acr01"
  location            = azurerm_resource_group.natus-aks.location
  resource_group_name = azurerm_resource_group.natus-aks.name
  subnet_id           = azurerm_subnet.global.id

  private_service_connection {
    name                           = "psc-acr-cac-001"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-acr-cac-001"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
  }
}
#KV
#resource "azurerm_key_vault" "kv" {
#  name                = "kv-natus01"
#  location            = azurerm_resource_group.natus-aks.location
#  resource_group_name = azurerm_resource_group.natus-aks.name
#  tenant_id           = var.tenant
#  public_network_access_enabled = false

#  sku_name = "standard"

#  access_policy {
#    tenant_id = var.tenant
#    object_id = azurerm_user_assigned_identity.pod.principal_id
#
#    secret_permissions = [
#      "Get", "List",
#    ]
#  }
#}

resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.natus-aks.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv1" {
  name                  = "pdznl-vault-cac-001"
  resource_group_name   = azurerm_resource_group.natus-aks.name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

#resource "azurerm_private_endpoint" "kv" {
#  name                = "pe-vault-cac-001"
#  location            = azurerm_resource_group.natus-aks.location
#  resource_group_name = azurerm_resource_group.natus-aks.name
#  subnet_id           = azurerm_subnet.global.id
#
#  private_service_connection {
#    name                           = "psc-vault01"
#    private_connection_resource_id = azurerm_key_vault.kv.id
#    subresource_names              = ["vault"]
#    is_manual_connection           = false
#  }
#
#  private_dns_zone_group {
#    name                 = "pdzg-vault-cac-001"
#    private_dns_zone_ids = [azurerm_private_dns_zone.kv.id]
#  }
#  
#}

#AKS
resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-aks01"
  location            = azurerm_resource_group.natus-aks.location
  resource_group_name = azurerm_resource_group.natus-aks.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.natusaks.azmk8s.io"
  resource_group_name = azurerm_resource_group.natus-aks.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "aks1" {
  name                  = "pdz-aks01"
  resource_group_name   = azurerm_resource_group.natus-aks.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
#identity
resource "azurerm_user_assigned_identity" "aks" {
  name                = "id-aks01"
  resource_group_name = azurerm_resource_group.natus-aks.name
  location            = azurerm_resource_group.natus-aks.location
}
resource "azurerm_user_assigned_identity" "pod" {
  name                = "id-pod01"
  resource_group_name = azurerm_resource_group.natus-aks.name
  location            = azurerm_resource_group.natus-aks.location
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks1"
  location            = azurerm_resource_group.natus-aks.location
  resource_group_name = azurerm_resource_group.natus-aks.name
  dns_prefix          = "exampleaks1"
  private_cluster_enabled = true

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
    Environment = "Develop"
    Department  = "EH"
    Createdby   = "Terraform"
    EmailOwner  = "acardenas@readymind.ms"
    Client      = "Natus"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}



#BD
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "sqlserver-natus01"
  resource_group_name          = azurerm_resource_group.natus-aks.name
  location                     = azurerm_resource_group.natus-aks.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}
resource "azurerm_mssql_database" "mysql" {
  name           = "mysqldb-natus"
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  #license_type   = "LicenseIncluded"
  #max_size_gb    = 1
  #read_scale     = true
  sku_name       = "Basic"
  #zone_redundant = false
  #enclave_type   = "VBS"

  tags = {
    foo = "bar"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
