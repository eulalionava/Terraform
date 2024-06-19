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

resource "azuread_application" "aplication" {
  display_name = "ap-apenshift"
}

resource "azuread_service_principal" "asp" {
  client_id = azuread_application.aplication.client_id
}

resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.asp.object_id
}

resource "azurerm_redhat_openshift_cluster" "aksopenshift" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location

  cluster_profile {
    domain               = var.domain
    resource_group_id    = var.resource_group_id
    version              = var.openshift_version
  }

  network_profile {
    pod_cidr            = var.pod_cidr
    service_cidr        = var.service_cidr
  }

  main_profile {
    vm_size             = var.master_vm_size
    subnet_id           = var.master_subnet_id
  }

  api_server_profile {
    visibility          = var.apiserver_visibility
  }

  ingress_profile {
    name                = "default"
    visibility          = var.ingress_visibility
  }
  

  worker_profile {
    vm_size             = var.worker_vm_size
    disk_size_gb        = var.worker_disk_size
    subnet_id           = var.worker_subnet_id
    node_count               = var.worker_count
  }

  service_principal {
    client_id     = azuread_application.aplication.client_id
    client_secret = azuread_service_principal_password.app.value
  }



  tags = var.tags
}

output "openshift_cluster_id" {
  value = azurerm_redhat_openshift_cluster.aksopenshift.id
}