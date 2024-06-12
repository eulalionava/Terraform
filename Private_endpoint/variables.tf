variable "location" {
    type = string
    description = "localizacion de los recursos"
}

variable "resource_group_name" {
    description = "The name of the resource group where the container registry will be created."
    type        = string
}

variable "private_endpoint_name" {
  description = "The name of the private endpoint."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the private endpoint."
  type        = string
}

variable "acr_id" {
  description = "The ID of the container registry."
  type        = string
}