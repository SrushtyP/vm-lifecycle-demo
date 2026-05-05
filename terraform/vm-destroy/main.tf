# Public IP
resource "azurerm_public_ip" "pip" {
  count               = var.destroy_enabled ? 0 : 1
  name                = "vm-destroy-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  count               = var.destroy_enabled ? 0 : 1
  name                = "vm-destroy-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[0].id
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.destroy_enabled ? 0 : 1
  name                = "vm-destroy"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic[0].id
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
    lifecycle   = "destroy"
    environment = "test"
    demo        = "vm-lifecycle"
  }
}