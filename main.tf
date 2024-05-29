#CLIENTE 1
locals {
  client_name   = "NombreCliente1" #Agregue el nombre del cliente
  client_number = 1                #Agregue el numero de cliente
  location      = "eastus"         #Agregue la region
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
    resource_group_name = module.Cliente1_RG.rg_pef_name_out
}

#Crear vm para agente
#Crear vm para grafana y prometheus