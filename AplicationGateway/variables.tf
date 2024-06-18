variable "name" {
  description = "The name of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the Application Gateway"
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the Application Gateway"
  type        = string
}

variable "sku_tier" {
  description = "The SKU tier of the Application Gateway"
  type        = string
}

variable "capacity" {
  description = "The capacity of the Application Gateway"
  type        = number
}

variable "subnet_id" {
  description = "The subnet ID for the Application Gateway"
  type        = string
}

variable "frontend_port" {
  description = "The frontend port for the Application Gateway"
  type        = number
}


variable "backend_port" {
  description = "The backend port for the Application Gateway"
  type        = number
}