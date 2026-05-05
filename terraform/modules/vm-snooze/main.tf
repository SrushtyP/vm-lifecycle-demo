# Public IP
resource "azurerm_public_ip" "pip" {
  name                = "vm-snooze-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "vm-snooze-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-snooze"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    lifecycle   = "snooze"
    environment = "development"
    demo        = "vm-lifecycle"
  }
}

# Snooze = deallocate the VM
# Disk and NIC are retained, compute billing stops
resource "null_resource" "snooze" {
  count = var.snooze_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      az vm deallocate \
        --resource-group ${var.resource_group_name} \
        --name vm-snooze
    EOT
  }

  depends_on = [azurerm_linux_virtual_machine.vm]

  triggers = {
    snooze_enabled = var.snooze_enabled
  }
}

# Wake up = start the VM back
resource "null_resource" "wakeup" {
  count = var.snooze_enabled ? 0 : 1

  provisioner "local-exec" {
    command = <<EOT
      az vm start \
        --resource-group ${var.resource_group_name} \
        --name vm-snooze
    EOT
  }

  depends_on = [azurerm_linux_virtual_machine.vm]

  triggers = {
    snooze_enabled = var.snooze_enabled
  }
}