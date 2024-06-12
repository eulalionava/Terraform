resource "azurerm_network_interface" "network-interface" {
  name                = "nic-vm-windows-pef-devops-0"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "vm-windows-pef-devops-0"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "pefaiuser"
  admin_password      = "P@ssword1234!"

  network_interface_ids = [
    azurerm_network_interface.network-interface.id,
  ]

  os_disk {
    name                 = "vm-windows-pef-devops-0-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }  
}