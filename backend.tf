terraform {

  # Configuración del backend
  backend "azurerm" {
    storage_account_name = "storageterraform3"
    container_name       = "terraformcontainer"
    access_key           = ""
  }

  # Opciones adicionales de configuración
  # Aquí puedes agregar otras configuraciones de Terraform según sea necesario
}
