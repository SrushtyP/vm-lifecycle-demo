terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
}

# Resource Group shared across all VMs
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Shared Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vm-demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Shared Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "vm-demo-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Module: VM Running
module "vm_running" {
  source              = "./modules/vm-running"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = azurerm_subnet.subnet.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

# Module: VM Resize
module "vm_resize" {
  source              = "./modules/vm-resize"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = azurerm_subnet.subnet.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

# Module: VM Snooze
module "vm_snooze" {
  source              = "./modules/vm-snooze"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = azurerm_subnet.subnet.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}

# Module: VM Destroy
module "vm_destroy" {
  source              = "./modules/vm-destroy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = azurerm_subnet.subnet.id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
}