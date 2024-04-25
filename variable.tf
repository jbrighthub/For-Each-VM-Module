# #export TF_VAR_cidr="value"

variable "resource_group_name" {
  type        = string
  description = "resource group name"
  default     = "myrg1"
}

variable "azurerm_resource_group_location" {
  type    = string
  default = "Central India"

}

# variable "admin_password" {
#   default = "P@$$w0rd1234!"

# }

# variable "admin_username" {
#   default = "adminuser"

# }

# variable "number_of_vm" {
#   type = number

# }

variable "vm" {
  type = map(object({
    vm_name        = string
    nic_name       = string
    ip_name        = string
    admin_username = string
    admin_password = string

  }))
  default = {
    vm1 = {
      vm_name        = "VM1"
      nic_name       = "VM1-nic"
      ip_name        = "VM1-ip"
      admin_username = "VM1"
      admin_password = "P@$$w0rd1234!"
    }
    vm2 = {
      vm_name        = "VM2"
      nic_name       = "VM2-nic"
      ip_name        = "VM2-ip"
      admin_username = "VM2"
      admin_password = "P@$$w0rd1234!"
    }

  }
}