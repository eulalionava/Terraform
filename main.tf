module "Cliente1"{
    source = "./Cliente1/ResourceGroup"
    client_name = "NombreCliente1" #coloque el nombre del cliente nuevo
    location = "eastus"
    number = 1 
}

#Crear vm para agente
#Crear vm para grafana y prometheus