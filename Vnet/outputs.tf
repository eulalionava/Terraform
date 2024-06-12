output "subnet_id_pool_out" {
  value = azurerm_subnet.subnet-aks.id
}

#output "azurerm_virtual_network_id" {
#  value = azurerm_virtual_network.k8.id
#}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}
output "subnet_id_devops0_out" {
  value = azurerm_subnet.subnet-devops0.id
}
output "subnet_id_devops1_out" {
  value = azurerm_subnet.subnet-devops1.id
}
output "subnet_id_devops1_out" {
  value = azurerm_subnet.subnet-bastion.id
}