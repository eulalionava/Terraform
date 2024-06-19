output "subnet_id_pool_out" {
  value = azurerm_subnet.subnet-aks.id
}


output "subnet_id" {
  value = azurerm_subnet.subnet.id
}
output "subnet_id_devops0_out" {
  value = azurerm_subnet.subnet-devops0.id
}
output "subnet_id_devops1_out" {
  value = azurerm_subnet.subnet-devops1.id
}

output "subnet_id_devops2_out" {
  value = azurerm_subnet.subnet-azurebastion.id
}

//Nombres de Maquinas Virtuales
output "virtual_network_hub_id" {
  value = azurerm_virtual_network.k8.id
}

output "virtual_network_hub_name" {
  value = azurerm_virtual_network.k8.name
}

output "virtual_network_hub_address" {
  value = azurerm_virtual_network.k8.address_space
}

/*
output "subnet_id_bastion_out" {
  value = azurerm_subnet.subnet-bastion.id
}*/