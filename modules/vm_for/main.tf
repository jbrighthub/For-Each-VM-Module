resource "azurerm_network_interface" "vnet" {
  name                = each.value.nic_name
  location            = var.azurerm_resource_group_location
  resource_group_name = var.resource_group_name
  for_each            = var.vm

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnetid
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vnet[each.key].id
  }
  # depends_on = [azurerm_virtual_network.vnet, azurerm_public_ip.vnet]
}

resource "azurerm_network_interface_security_group_association" "vnet" {
  network_interface_id      = azurerm_network_interface.vnet[each.key].id
  network_security_group_id = azurerm_network_security_group.vnet.id
  for_each                  = var.vm

}

resource "azurerm_windows_virtual_machine" "vnet" {
  name                = each.value.vm_name
  resource_group_name = var.resource_group_name
  location            = var.azurerm_resource_group_location
  size                = "Standard_F2"
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
  for_each            = var.vm
  network_interface_ids = [
    azurerm_network_interface.vnet[each.key].id,
  ]

  os_disk {
    name                 = "osdisk-${each.value.vm_name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  depends_on = [azurerm_network_interface.vnet]
}
resource "azurerm_public_ip" "vnet" {
  name                = each.value.ip_name
  location            = var.azurerm_resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  for_each            = var.vm

}

resource "azurerm_network_security_group" "vnet" {
  name                = "nsg"
  location            = var.azurerm_resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}