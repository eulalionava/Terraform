variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "resource_group_id" {
  description = "The id of the resource group "
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
}

variable "master_subnet_name" {
  description = "The name of the master subnet"
  type        = string
}

variable "master_subnet_prefix" {
  description = "The address prefix of the master subnet"
  type        = string
}

variable "subnet_id_pool_out" {
  description = "The subnet ID for the Application Gateway"
  type        = string
}

variable "worker_subnet_name" {
  description = "The name of the worker subnet"
  type        = string
}

variable "worker_subnet_prefix" {
  description = "The address prefix of the worker subnet"
  type        = string
}

variable "cluster_name" {
  description = "The name of the OpenShift cluster"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the Application Gateway"
  type        = string
}


variable "domain" {
  description = "The domain of the OpenShift cluster"
  type        = string
}

variable "openshift_version" {
  description = "The version of OpenShift"
  type        = string
}

variable "master_vm_size" {
  description = "The VM size for the master nodes"
  type        = string
}

variable "worker_vm_size" {
  description = "The VM size for the worker nodes"
  type        = string
}

variable "worker_disk_size" {
  description = "The disk size for the worker nodes"
  type        = number
}

variable "worker_count" {
  description = "The number of worker nodes"
  type        = number
}

variable "pod_cidr" {
  description = "The CIDR for the pod network"
  type        = string
}

variable "service_cidr" {
  description = "The CIDR for the service network"
  type        = string
}

variable "apiserver_visibility" {
  description = "The visibility of the API server"
  type        = string
}

variable "ingress_visibility" {
  description = "The visibility of the ingress controller"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}