variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

# This is the key variable — change this to resize
# Before: Standard_B1s  After: Standard_B2s
variable "vm_size" {
  type        = string
  description = "VM size — change to resize. Before: Standard_B1s | After: Standard_B2s"
  default     = "Standard_B1s"
}

# Disk size — change to resize
# Before: 30gb  After: 64gb
variable "disk_size_gb" {
  type        = number
  description = "Disk size in GB — change to resize. Before: 30 | After: 64"
  default     = 30
}