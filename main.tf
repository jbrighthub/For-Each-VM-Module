terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.100.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "vnet" {
  name     = var.resource_group_name
  location = var.azurerm_resource_group_location

}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.0.0.0/16"]

}
resource "azurerm_subnet" "vnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}

module "for_vm" {
  source                          = "./modules/vm_for"
  resource_group_name             = azurerm_resource_group.vnet.name
  subnetid                        = azurerm_subnet.vnet.id
  azurerm_resource_group_location = azurerm_resource_group.vnet.location
}

output "public_ip" {
  value = module.for_vm.publicip
}

output "private_ip" {
  value = module.for_vm.vm_private_ip
}








  