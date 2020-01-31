provider "azurerm" { }

resource "azurerm_resource_group" "propsblockdevnode" {
  name = "propsblockdevnode"
  location = "eastus"
}

resource "azurerm_virtual_network" "propsblockdevnode" {
  name = "propsblockdevnode"
  address_space = ["10.0.0.0/16"]
  location = "eastus"
  resource_group_name = azurerm_resource_group.propsblockdevnode.name
}

resource "azurerm_subnet" "propsblockdevnode" {
  name = "propsblockdevnode"
  resource_group_name = azurerm_resource_group.propsblockdevnode.name
  virtual_network_name = azurerm_virtual_network.propsblockdevnode.name
  address_prefix = "10.0.2.0/24"
}

resource "azurerm_public_ip" "propsblockdevnode" {
    name                         = "propsblockdevnode"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.propsblockdevnode.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "propsblockdevnode" {
    name                = "propsblockdevnode"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.propsblockdevnode.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "propsblockdevnode" {
    name                        = "propsblockdevnode"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.propsblockdevnode.name
    network_security_group_id   = azurerm_network_security_group.propsblockdevnode.id

    ip_configuration {
        name                          = "propsblockdevnode"
        subnet_id                     = azurerm_subnet.propsblockdevnode.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.propsblockdevnode.id
    }
}

resource "azurerm_storage_account" "propsblockdevnode" {
    name                        = "propsblockdevnode"
    resource_group_name         = azurerm_resource_group.propsblockdevnode.name
    location                    = "eastus"
    account_replication_type    = "LRS"
    account_tier                = "Standard"
}

resource "azurerm_virtual_machine" "propsblockdevnode" {
    name                  = "propsblockdevnode"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.propsblockdevnode.name
    network_interface_ids = [azurerm_network_interface.propsblockdevnode.id]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "propsblockdevnode"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "propsblockdevnode"
        admin_username = "propsblockadmin"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = var.ssh_key
        }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.propsblockdevnode.primary_blob_endpoint
    }

    provisioner "local-exec" {
        command     = <<EOF
        sudo apt-get update
        sudo apt install docker.io -y
        EOF
    }
}