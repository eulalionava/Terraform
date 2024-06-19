// resource "azurerm_resource_group" "example" {
//   name     = var.resource_group_name
//   location = var.location
// }

// resource "azurerm_virtual_network" "example" {
//   name                = var.vnet_name
//   address_space       = var.vnet_address_space
//   location            = var.location
//   resource_group_name = azurerm_resource_group.example.name
// }

// resource "azurerm_subnet" "master_subnet" {
//   name                 = var.master_subnet_name
//   resource_group_name  = azurerm_resource_group.example.name
//   virtual_network_name = azurerm_virtual_network.example.name
//   address_prefixes     = [var.master_subnet_prefix]
//   service_endpoints    = ["Microsoft.ContainerRegistry"]
// }

// resource "azurerm_subnet" "worker_subnet" {
//   name                 = var.worker_subnet_name
//   resource_group_name  = azurerm_resource_group.example.name
//   virtual_network_name = azurerm_virtual_network.example.name
//   address_prefixes     = [var.worker_subnet_prefix]
//   service_endpoints    = ["Microsoft.ContainerRegistry"]
// }

resource "azurerm_redhat_openshift_cluster" "example" {
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  cluster_profile {
    domain               = var.domain
    resource_group_id    = azurerm_resource_group.example.id
    version              = var.openshift_version
  }

  master_profile {
    vm_size             = var.master_vm_size
    subnet_id           = azurerm_subnet.master_subnet.id
  }

  worker_profiles {
    name                = "worker"
    vm_size             = var.worker_vm_size
    disk_size_gb        = var.worker_disk_size
    subnet_id           = azurerm_subnet.worker_subnet.id
    count               = var.worker_count
  }

  network_profile {
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
  }

  apiserver_profile {
    visibility          = var.apiserver_visibility
  }

  ingress_profile {
    name                = "default"
    visibility          = var.ingress_visibility
  }

  tags = var.tags
}

output "openshift_cluster_id" {
  value = azurerm_redhat_openshift_cluster.example.id
}