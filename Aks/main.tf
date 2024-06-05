resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.eastus.azmk8s.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "user_assigned" {
  name                = "aks-example-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

/resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_private_dns_zone.example.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}

resource "azurerm_kubernetes_cluster" "example" {
  name                    = "aksexamplewithprivatednszone1"
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = "aksexamplednsprefix1"
  private_cluster_enabled = true
  private_dns_zone_id     = azurerm_private_dns_zone.dns.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    vnet_subnet_id  = var.vnet_subnet_id
  }
  
}