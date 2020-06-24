terraform {
  required_version = "~> 0.12.25"
  required_providers {
    azurerm = "~> 2.15"
  }
}

# Configure the Azure Resource Manager Provider
provider "azurerm" {
  features {}
}
