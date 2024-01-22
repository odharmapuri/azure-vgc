module "network" {
  source              = "./modules/network"
  rgname              = var.rgname
  rglocation          = var.rglocation
  prefix              = var.prefix
  vnet_cidr_prefix    = var.vnet_cidr_prefix
  subnet1_cidr_prefix = var.subnet1_cidr_prefix
  subnet2_cidr_prefix = var.subnet2_cidr_prefix
  tags                = var.tags
}

module "availset" {
  depends_on = [
    module.network
  ]
  source     = "./modules/availset"
  rgname     = var.rgname
  rglocation = var.rglocation
  web_snet   = module.network.snet1
  prefix     = var.prefix
  tags       = var.tags
}

module "vm" {
  depends_on = [
    module.network
  ]
  source     = "./modules/vm"
  rgname     = var.rgname
  rglocation = var.rglocation
  prefix     = var.prefix
  web_snet   = module.network.snet1
  tags       = var.tags
}

module "loadbalancer" {
  depends_on = [
    module.availset
  ]
  source             = "./modules/loadbalancer"
  rgname             = var.rgname
  rglocation         = var.rglocation
  prefix             = var.prefix
  webservers         = module.availset.webservers
  webserver-nic-id   = module.availset.webserver-nic-id
  webserver-nic-name = module.availset.webserver-nic-name
  tags               = var.tags
}

