# Public IP
resource "azurerm_public_ip" "webmac_pub_ip" {
  name                = "${var.prefix}-server_pub_ip"
  location            = var.rglocation
  resource_group_name = var.rgname
  allocation_method   = "Static"
  domain_name_label   = "s367899"
}

# Creating NIC for webmac
resource "azurerm_network_interface" "webmac-nic" {
  name                = "webmac-nic"
  location            = var.rglocation
  resource_group_name = var.rgname
  ip_configuration {
    name                          = "int-ipconf"
    subnet_id                     = var.web_snet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.webmac_pub_ip.id
  }
}
/*
# Create (and display) an SSH key
resource "tls_private_key" "web_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}*/

# Create virtual machine
resource "azurerm_linux_virtual_machine" "server" {
  name                            = "${var.prefix}-webmac"
  resource_group_name             = var.rgname
  location                        = var.rglocation
  size                            = "Standard_B1s"
  admin_username                  = "azdemo"
  admin_password                  = "Wildcraft$7899"
  network_interface_ids           = [azurerm_network_interface.webmac-nic.id]
  disable_password_authentication = false
  computer_name                   = "webmac"
  custom_data                     = filebase64("./modules/vm/server.sh")

  admin_ssh_key {
    username   = "azdemo"
    public_key = file("./modules/vm/azdemo.pub")
    #public_key = tls_private_key.web_ssh_key.public_key_openssh
  }

  os_disk {
    name                 = "webmac-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = var.tags
}