variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
  default     = "vm-lifecycle-demo-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralus"
}

variable "admin_username" {
  description = "Admin username for all VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}