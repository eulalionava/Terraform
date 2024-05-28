module "Cliente1"{
    source = "./Cliente1/ResourceGroup"
    client_name = "NombreCliente1"
    location = "eastus"
}

#Crear vm para agente
#Crear vm para grafana y prometheus