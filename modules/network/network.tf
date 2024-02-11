resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.rglocation
}
resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.vnet_cidr_prefix]
}

resource "azurerm_subnet" "snet1" {
  name                 = "${var.prefix}-snet1"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.subnet1_cidr_prefix]
}
/*
resource "azurerm_subnet" "snet2" {
  name                 = "${var.prefix}-snet2"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = [var.subnet2_cidr_prefix]
}

resource "azurerm_public_ip" "pub-ip" {
  count               = 3
  name                = "${var.prefix}-pub-ip${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "azdemo${count.index}-367899"
}*/

resource "azurerm_network_security_group" "frontsg" {
  name                = "${var.prefix}-frontsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "rabbitmq"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "memcached"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
/*
resource "azurerm_network_security_group" "backsg" {
  name                = "${var.prefix}-backsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
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

# NOTE: this allows RDP from any network
resource "azurerm_network_security_rule" "allow-ssh-web" {
  name                        = "ssh-web"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.frontsg.name
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22,80,8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}*/

resource "azurerm_subnet_network_security_group_association" "sg_subnet_assoc1" {
  subnet_id                 = azurerm_subnet.snet1.id
  network_security_group_id = azurerm_network_security_group.frontsg.id
}
/*
resource "azurerm_subnet_network_security_group_association" "sg_subnet_assoc2" {
  subnet_id                 = azurerm_subnet.snet2.id
  network_security_group_id = azurerm_network_security_group.backsg.id
}

# Create network interface
resource "azurerm_network_interface" "nic1" {
  name                = "${var.prefix}-nic1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.prefix}-nic1_conf"
    subnet_id                     = azurerm_subnet.snet1.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}
resource "azurerm_network_interface" "nic2" {
  name                = "${var.prefix}-nic2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.prefix}-nic2_conf"
    subnet_id                     = azurerm_subnet.snet2.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic_sg_asso1" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.frontsg.id
}
resource "azurerm_network_interface_security_group_association" "nic_sg_asso2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.backsg.id
}*/