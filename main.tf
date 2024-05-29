#CLIENTE 1
locals {
  client_name   = "NombreCliente1" #Agregue el nombre del cliente
  client_number = 1                #Agregue el numero de cliente
  location      = "eastus"         #Agregue la region
  tenant        = "08c7a78d-587d-4487-962e-93c5fb54c7bf" #Agregue el tenant
  key_vault_manager = "7d7c8ee7-f410-4f01-9c33-3744f87ff4e8"  #objectId del administrador de KV
}
module "Cliente1_RG"{
    source = "./Cliente1/ResourceGroup"
    client_name = local.client_name 
    location = local.location
    client_number = local.client_number
}
module "Cliente1_ACR"{
    source = "./Cliente1/ContainerRegistry"
    client_name = local.client_name
    location = local.location
    client_number = local.client_number
    resource_group_name = module.Cliente1_RG.rg_aks_name_out
}

#Crear vm para agente
#Crear vm para grafana y prometheus