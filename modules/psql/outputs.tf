# Output connection string
output "psql_fqdn" {
  value = azurerm_postgresql_server.psql_server.fqdn
}
output "psql_port" {
  value = azurerm_postgresql_server.psql_server.version == "14" ? "5432" : "5433"
}