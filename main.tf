locals {
  location      = "eastus"         #Agregue la region
  tenant        = "08c7a78d-587d-4487-962e-93c5fb54c7bf" #Agregue el tenant
  key_vault_manager = "a493aae0-a6c0-4b99-ac6a-eeebb51076c8"  #objectId del administrador de KV
}
module "ResourceGroup"{
    source = "./ResourceGroup"
    location = local.location
}
module "Vnet"{
    source = "./Vnet"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_aks_name_out
    resource_group_name_ntw = module.ResourceGroup.rg_ntw_name_out
}
module "ContainerRegistry"{
    source = "./ContainerRegistry"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_aks_name_out
}

module "KeyVault"{
    source = "./KeyVault"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_aks_name_out
    key_vault_manager = local.key_vault_manager
    tenant = local.tenant
}

module "VM"{
    source = "./VM"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_ntw_name_out
    vnet_subnet_id = module.Vnet.subnet_id_devops0_out
}

// module "vmwindows" {
//   source                 = "./VMWindows"
//   location               = local.location
//   resource_group_name    = module.ResourceGroup.rg_aks_name_out
//   network_interface_id   = module.Vnet.subnet_id_devops0_out
// }
/*
# Llamar al módulo de Private Endpoint
module "Private_endpoint" {
  source                        = "./Private_endpoint"
  private_endpoint_name         = "private-endpoint-pef"
  location                      = local.location
  resource_group_name           = module.ResourceGroup.rg_aks_name_out
  subnet_id                     = module.Vnet.azurerm_subnet_id
  private_service_connection_name = "private-service-connection"
  acr_id                        = module.ContainerRegistry.acr_id
}
*/

module "StorageAccount"{
    source = "./StorageAccounts"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_cdn_name_out
}
module "Aks"{
    source = "./Aks"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_aks_name_out
    vnet_subnet_id = module.Vnet.subnet_id
    vnet_subnet_id_pool = module.Vnet.subnet_id_pool_out
}
module "ServiceBus"{
    source = "./ServiceBus"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_aks_name_out
}
#Crear vm para agente
#Crear vm para grafana y prometheus