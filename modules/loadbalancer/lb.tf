# Public IP
resource "azurerm_public_ip" "pub_ip" {
  name                = "${var.prefix}-pub_ip"
  location            = var.rglocation
  resource_group_name = var.rgname
  allocation_method   = "Static"
  domain_name_label   = "a367899"
}

# Create a load balancer
resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-lb"
  location            = var.rglocation
  resource_group_name = var.rgname
  depends_on = [ azurerm_public_ip.pub_ip ]
  frontend_ip_configuration {
    name                 = "${var.prefix}-lb"
    public_ip_address_id = azurerm_public_ip.pub_ip.id
  }
}

# Create a load balancer backend pool
resource "azurerm_lb_backend_address_pool" "lb_pool" {
  name                = "${var.prefix}-lb_pool"
  loadbalancer_id     = azurerm_lb.lb.id
  depends_on = [ 
    azurerm_lb.lb,
    var.webservers
  ]
}

# LB backend pool NIC association
resource "azurerm_network_interface_backend_address_pool_association" "nic-backendpool-assoc" {
  count = 3
  network_interface_id = var.webserver-nic-id[count.index]
  ip_configuration_name = "int-ipconf"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_pool.id
  depends_on = [ 
    var.webservers,
    azurerm_lb_backend_address_pool.lb_pool
  ]
}

# Create a load balancer probe
resource "azurerm_lb_probe" "lb_probea" {
  name                = "${var.prefix}-lb_probea"
  loadbalancer_id     = azurerm_lb.lb.id
  port                = 8080
  protocol            = "Http"
  request_path        = "/"
  interval_in_seconds = 15
  number_of_probes    = 2
  depends_on = [
    azurerm_lb_backend_address_pool.lb_pool
  ]
}
resource "azurerm_lb_probe" "lb_probeb" {
  name                = "${var.prefix}-lb_probeb"
  loadbalancer_id     = azurerm_lb.lb.id
  port                = 22
  protocol            = "Tcp"
  #request_path        = "/"
  interval_in_seconds = 15
  number_of_probes    = 2
  depends_on = [
    azurerm_lb_backend_address_pool.lb_pool
  ]
}

# Create a load balancer rule
resource "azurerm_lb_rule" "lb_rule1" {
  name                = "${var.prefix}-lb_rule1"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  frontend_port       = 80
  backend_port        = 8080
  frontend_ip_configuration_name = azurerm_lb.lb.name
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.lb_pool.id ]
  probe_id                       = azurerm_lb_probe.lb_probea.id
  depends_on = [ 
    azurerm_lb_backend_address_pool.lb_pool,
    azurerm_lb_probe.lb_probea
  ]
}
# Create a load balancer rule
resource "azurerm_lb_rule" "lb_rule2" {
  name                = "${var.prefix}-lb_rule2"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  frontend_port       = 22
  backend_port        = 22
  frontend_ip_configuration_name = azurerm_lb.lb.name
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.lb_pool.id ]
  probe_id                       = azurerm_lb_probe.lb_probeb.id
  depends_on = [ 
    azurerm_lb_backend_address_pool.lb_pool,
    azurerm_lb_probe.lb_probeb
  ]
}





/*
# Create a Linux virtual machine scale set
resource "azurerm_linux_virtual_machine_scale_set" "lb_scaleset" {
  name                = "${var.prefix}-webserver"
  resource_group_name = var.rgname
  location            = var.rglocation
  sku                 = "Standard_B1s"
  instances           = 3
  admin_username      = "azdemo"
  admin_password      = "azdemo"
  disable_password_authentication = true
  user_data = filebase64("./modules/loadbalancer/web.sh")

  admin_ssh_key {
    username   = "azdemo"
    public_key = file("./modules/vm/azdemo.pub")
    #public_key = tls_private_key.web_ssh_key.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "${var.prefix}-webserver_nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.web_snet

      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.lb_pool.id
      ]
    }
  }
}*/