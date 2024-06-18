locals {
  location      = "eastus"         #Agregue la region
  tenant        = "08c7a78d-587d-4487-962e-93c5fb54c7bf" #Agregue el tenant
  key_vault_manager = "a493aae0-a6c0-4b99-ac6a-eeebb51076c8"  #objectId del administrador de KV
  identifier_uris = ["https://example.com"]
  capacity = 2
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

module "application_gateway" {
  source              = "./AplicationGateway"
  name                = "appgw01"
  resource_group_name = module.ResourceGroup.rg_hub_name_out
  location            = local.location
  sku_name            = "Standard_v2"
  sku_tier            = "Standard_v2"
  capacity            = local.capacity
  subnet_id           = module.Vnet.subnet_id
  frontend_port       = 80
  backend_port        = 80
}

module "app_configuration" {
  source              = "./AppConfiguration"
  name                = "myappconfig"
  resource_group_name = module.ResourceGroup.rg_hub_name_out
  location            = local.location
}

// module "app_registration" {
//   source                          = "./AppRegistration"
//   identifier_uris                 = ["https://example.com"]
//   home_page_url                   = "https://example.com"
//   redirect_uris                   = ["https://example.com/redirect"]
//   logout_url                      = "https://example.com/logout"
//   access_token_issuance_enabled   = true
//   id_token_issuance_enabled       = true
//   resource_app_id                 = local.tenant
//   resource_access_id              = "user.read"
//   client_secret                   = "secret"
// }

/*
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

module "vmwindows" {
  source                 = "./VMWindows"
  location               = local.location
  resource_group_name    = module.ResourceGroup.rg_ntw_name_out
  vnet_subnet_id         = module.Vnet.subnet_id_devops0_out
}
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
/*
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
module "Bastion"{
    source = "./Bastion"
    location = local.location
    resource_group_name = module.ResourceGroup.rg_hub_name_out
    vnet_subnet_id = module.Vnet.subnet_id_devops2_out
}*/
#Crear vm para agente
#Crear vm para grafana y prometheus