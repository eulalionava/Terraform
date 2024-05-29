variable "tenant" {
    description = "The Tenant ID where the Key Vault is located."
    type        = string
}
variable "key_vault_manager" {
    description = "The Object ID of the Service Principal to which permissions will be assigned."
    type        = string
}
variable "location" {
    type = string
    description = "localizacion de los recursos"
}
variable "resource_group_name" {
    description = "The name of the resource group where the container registry will be created."
    type        = string
}