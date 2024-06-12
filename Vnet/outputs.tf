output "azurerm_subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "subnet_id_pool_out" {
  value = azurerm_subnet.subnet-aks.id
}