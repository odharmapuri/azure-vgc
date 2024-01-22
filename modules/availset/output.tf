output "webserver-nic-id" {
  value = azurerm_network_interface.webserver-nic[*].id
}
output "webserver-nic-name" {
  value = azurerm_network_interface.webserver-nic[*].name
}
output "webservers" {
  value = azurerm_linux_virtual_machine.webserver[*].id
}
/*output "ipcon" {
  value = azurerm_network_interface.webserver-nic[*].ip_configuration
}*/