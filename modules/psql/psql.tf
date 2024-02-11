resource "azurerm_postgresql_server" "psql_server" {
  name                              = "${var.prefix}-psql-server"
  location                          = var.rglocation
  resource_group_name               = var.rgname
  create_mode                       = "Default"
  administrator_login               = var.psql_admin
  administrator_login_password      = var.psql_pass
  sku_name                          = "B_Gen5_1" # Adjust as needed
  version                           = "11"       # Adjust as needed
  storage_mb                        = 5120       # Adjust as needed
  ssl_enforcement_enabled           = false
  ssl_minimal_tls_version_enforced  = "TLSEnforcementDisabled"
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  auto_grow_enabled                 = false
  public_network_access_enabled     = true
  infrastructure_encryption_enabled = false
}

resource "azurerm_postgresql_database" "psql_db" {
  name                = "${var.prefix}-psql-db"
  resource_group_name = var.rgname
  server_name         = azurerm_postgresql_server.psql_server.name
  charset             = "UTF8"
  collation           = "en-US"
}