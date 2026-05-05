output "public_ip" {
  value       = var.destroy_enabled ? "N/A — VM destroyed" : azurerm_public_ip.pip[0].ip_address
  description = "Public IP — only available when VM exists"
}

output "vm_id" {
  value       = var.destroy_enabled ? "N/A — VM destroyed" : azurerm_linux_virtual_machine.vm[0].id
  description = "VM ID — only available when VM exists"
}

output "destroy_status" {
  value       = var.destroy_enabled ? "DESTROYED — zero cost, all resources deleted" : "PROVISIONED — billing active"
  description = "Current destroy status of the VM"
}

output "monthly_savings_inr" {
  value       = var.destroy_enabled ? "₹4800 saved per month" : "₹0 saved — VM still running"
  description = "Monthly savings after destroy"
}