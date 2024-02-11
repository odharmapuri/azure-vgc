output "fqdn" {
  description = "fully qualified domain name of DNS record associated with public ip"
  value       = azurerm_public_ip.pub_ip.fqdn
}