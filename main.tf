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

module "appservice" {
  source     = "./modules/appservice"
  rgname     = var.rgname
  rglocation = var.rglocation
  prefix     = var.prefix
}

module "psql" {
  source     = "./modules/psql"
  rgname     = var.rgname
  rglocation = var.rglocation
  prefix     = var.prefix
  psql_admin = var.psql_admin
  psql_pass  = var.psql_pass
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

/*
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
  num = var.num
  admusr = var.admusr
  admpwd = var.admpwd
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
  num = var.num
}
*/