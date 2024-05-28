#CLIENTE 1
module "Cliente1_RG"{
    source = "./Cliente1/ResourceGroup"
    client_name = "NombreCliente1" #coloque el nombre del cliente nuevo
    location = "eastus"
    client_number = 1 #coloque el numero del cliente nuevo
}
module "Cliente1_ACR"{
    source = "./Cliente1/ContainerRegistry"
    location = "eastus"
}

#Crear vm para agente
#Crear vm para grafana y prometheus