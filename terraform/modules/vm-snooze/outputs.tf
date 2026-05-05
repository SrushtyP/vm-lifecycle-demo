output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "snooze_status" {
  value       = var.snooze_enabled ? "SNOOZED — compute billing stopped" : "AWAKE — compute billing active"
  description = "Current snooze status of the VM"
}