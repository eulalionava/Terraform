resource "azurerm_network_interface" "network-interface" {
  name                = "nic-vm-win-pef-devops-0"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-win-pef-devops-0"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "pefaiuser"
  admin_password      = "P3f4i!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.network-interface.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }  
}