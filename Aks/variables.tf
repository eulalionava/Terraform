variable "location" {
    type = string
    description = "localizacion de los recursos"
}
variable "resource_group_name" {
    description = "The name of the resource group where the container registry will be created."
    type        = string
}
variable "vnet_subnet_id"{
    type = string
    description = "The ID of the subnet where the AKS cluster node pool will be located."
}