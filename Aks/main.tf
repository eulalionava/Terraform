resource "azurerm_private_dns_zone" "example" {
  name                = "privatelink.eastus.azmk8s.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "example" {
  name                = "aks-example-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_private_dns_zone.example.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}

module "Vnet"{
    source = "./Vnet"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_aks_name_out
}

resource "azurerm_kubernetes_cluster" "example" {
  source = "./Vnet"
  name                    = "aksexamplewithprivatednszone1"
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = "aksexamplednsprefix1"
  private_cluster_enabled = true
  private_dns_zone_id     = azurerm_private_dns_zone.example.id

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    vnet_subnet_id  = module.Vnet.subnet_id_out
  }
  
  depends_on = [
    azurerm_role_assignment.example,
  ]
}