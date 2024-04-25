 output "publicip" {
#   value = azurerm_windows_virtual_machine.vnet[*].public_ip_address
    value = [for ip in values(azurerm_windows_virtual_machine.vnet) : ip.public_ip_address]
 }


output "vm_private_ip" {
  value = [for pri_ip in values(azurerm_windows_virtual_machine.vnet) : pri_ip.private_ip_address]
}