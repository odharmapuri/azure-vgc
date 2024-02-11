# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
  /*backend "azurerm" {
    resource_group_name  = "azdemo-rg"
    storage_account_name = "backend367899"
    container_name       = "backend-container0"
    key                  = "azdemo.terraform.tfstate"
    #access_key           = "TWgdEJ1FslmqKqtclKLaccwEQ2QU9WJ8mXHOof1oARBpW+N+f3xCuqcjXSJuppDQl/8jjP3QUoYk+ASta0Raww=="
    #lock_table_name      = data.locktable.name
    #use_blob_lease       = true
  }*/
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = base64decode(var.client_secret)
  tenant_id       = var.tenant_id
  #skip_provider_registration = true #This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}
