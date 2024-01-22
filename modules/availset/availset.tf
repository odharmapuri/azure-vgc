# Creating availability set
resource "azurerm_availability_set" "availset" {
  name = "${var.prefix}-availset"
  location = var.rglocation
  resource_group_name = var.rgname
  tags = var.tags
}

# Creating NIC for Webservers
resource "azurerm_network_interface" "webserver-nic" {
  count = 3
  name = "${var.prefix}-webserver-nic${count.index}"
  location = var.rglocation
  resource_group_name = var.rgname
  ip_configuration {
    name = "int-ipconf"
    subnet_id = var.web_snet
    private_ip_address_allocation = "Dynamic"
  }
}

# Creating Azure Linux VMs
resource "azurerm_linux_virtual_machine" "webserver" {
  count = 3
  name                = "${var.prefix}-webserver${count.index}"
  resource_group_name = var.rgname
  location            = var.rglocation
  size                 = "Standard_B1s"
  admin_username      = "azdemo"
  admin_password      = "Wildcraft$7899"
  disable_password_authentication = false
  user_data = filebase64("./modules/availset/web.sh")
  network_interface_ids = [ azurerm_network_interface.webserver-nic[count.index].id ]
  availability_set_id = azurerm_availability_set.availset.id
  computer_name = "${var.prefix}-webserver${count.index}"

  admin_ssh_key {
    username   = "azdemo"
    public_key = file("./modules/vm/azdemo.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    name = "${var.prefix}-webserver${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  tags = var.tags
}