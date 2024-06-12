

output "subnet_id_pool_out" {
  value = azurerm_subnet.subnet-aks.id
}

output "azurerm_virtual_network_id" {
  value = azurerm_virtual_network.k8.id
}

output "azurerm_subnet_id" {
  value = azurerm_subnet.subnet.id
}