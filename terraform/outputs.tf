output "vm_running_public_ip" {
  description = "Public IP of the running VM"
  value       = module.vm_running.public_ip
}

output "vm_resize_public_ip" {
  description = "Public IP of the resize VM"
  value       = module.vm_resize.public_ip
}

output "vm_snooze_public_ip" {
  description = "Public IP of the snooze VM"
  value       = module.vm_snooze.public_ip
}

output "vm_destroy_public_ip" {
  description = "Public IP of the destroy VM"
  value       = module.vm_destroy.public_ip
}