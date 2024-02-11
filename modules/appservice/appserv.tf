resource "azurerm_app_service_plan" "azappplan" {
  name                = "${var.prefix}-app-plan"
  location            = var.rglocation
  resource_group_name = var.rgname
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "azapp" {
  name                = "${var.prefix}-app"
  location            = var.rglocation
  resource_group_name = var.rgname
  app_service_plan_id = azurerm_app_service_plan.azappplan.id

  site_config {
    java_version   = "1.8"
    java_container = "TOMCAT"
  }
}