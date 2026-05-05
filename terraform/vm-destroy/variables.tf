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

# false = VM exists and is running    — billing active
# true  = VM and all resources gone   — zero cost
variable "destroy_enabled" {
  type        = bool
  description = "true = destroy all VM resources | false = VM is provisioned"
  default     = false
}