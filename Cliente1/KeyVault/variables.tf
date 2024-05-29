variable "tenant" {
    description = "The Tenant ID where the Key Vault is located."
    type        = string
}
variable "service_principal_object_id" {
    description = "The Object ID of the Service Principal to which permissions will be assigned."
    type        = string
}