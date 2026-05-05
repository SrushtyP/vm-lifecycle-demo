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

# true  = VM is deallocated (snoozed)   — no compute cost
# false = VM is running (awake)          — full compute cost
variable "snooze_enabled" {
  type        = bool
  description = "true = deallocate VM (snooze) | false = start VM (wake up)"
  default     = true
}