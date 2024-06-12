resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.eastus.azmk8s.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "user_assigned" {
  name                = "k8s-pef-prd-eastus-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = azurerm_private_dns_zone.dns.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "k8s-pef-prd-eastus-001"
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = "aks-example"
  private_cluster_enabled = true
  private_dns_zone_id     = azurerm_private_dns_zone.dns.id

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.user_assigned.id]   
  }

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS3_v2"
    vnet_subnet_id  = var.vnet_subnet_id
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }
  
}
resource "azurerm_kubernetes_cluster_node_pool" "user-pool" {
  name                  = "k8s-pef-prd-eastus-pool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "B16als_v2"
  node_count            = 1
  vnet_subnet_id        = var.vnet_subnet_id_pool
}