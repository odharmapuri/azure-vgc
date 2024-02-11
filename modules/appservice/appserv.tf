resource "azurerm_service_plan" "azappplan" {
  name                = "${var.prefix}-app-plan"
  location            = var.rglocation
  resource_group_name = var.rgname
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "azapp" {
  name                = "${var.prefix}-vgpracapp"
  location            = var.rglocation
  resource_group_name = var.rgname
  service_plan_id     = azurerm_service_plan.azappplan.id

  site_config {
    always_on = true
    application_stack {
      java_version = "8"
      java_server  = "TOMCAT"
      java_server_version = "9"
      
    }
  }

  app_settings = {
    #"JAVA_OPTS"                = "-Xms1024M -Xmx1024M"
    #"WEBSITE_RUN_FROM_PACKAGE" = "1"
    PORT = 8080
    #WEBSITES_PORT = 8080
    # Specify the URL of the .war file to deploy
    #WAR_URL = "https://example.com/sample.war"
    #war = "./target/*.war"
  }
}