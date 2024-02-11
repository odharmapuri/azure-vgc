# Create a DNS zone
resource "azurerm_dns_zone" "example" {
  name                = "example.com"
  resource_group_name = azurerm_resource_group.example.name
}

# Create a DNS A record for the front end
resource "azurerm_dns_a_record" "example-front" {
  name                = "front"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  records             = [azurerm_public_ip.example.ip_address]
}

# Create a DNS A record for the back end
resource "azurerm_dns_a_record" "example-back" {
  name                = "back"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  records             = [azurerm_linux_virtual_machine_scale_set.example.private_ip_address]
}