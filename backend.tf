terraform {
  backend "azurerm" {
    storage_account_name = "storageterraform3"
    resource_group_name  = "RG-TESTLABS-RM"
    container_name       = "storagedemo"
  }
}