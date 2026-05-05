output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "current_vm_size" {
  value       = azurerm_linux_virtual_machine.vm.size
  description = "Current size of the VM — shows before/after resize"
}

output "current_disk_size_gb" {
  value       = azurerm_linux_virtual_machine.vm.os_disk[0].disk_size_gb
  description = "Current disk size in GB — shows before/after resize"
}