# Variables
variable "azurerm_subscription_id" {
  description = "The Azure subscription ID to use."
}

variable "azurerm_client_id" {
  description = "The Azure Application client ID to use."
}

variable "azurerm_client_secret" {
  description = "The Azure Application client secret to use."
}

variable "azurerm_tenant_id" {
  description = "The Azure tenant ID to use."
}

variable "environment" {
  description = "The name of the environment to create i.e. acceptance, production, staging"
}

variable "name_prefix" {
  description = "Prefix for resource names."
}

variable "location" {
  description = "The location where resources will be created."
  default     = "WestUS"
}

variable "plan" {
  type        = any
  default     = {}
  description = "App Service plan properties. This should be `plan` object."
}

variable "application" {
  description = "Type of Application."
}

variable "created_by" {
  description = "Creator of these resources"
}

variable "app_service_plan_sku_tier" {
  description = "App Service plan's SKU tier"
}

variable "app_service_plan_sku_size" {
  description = "App Service plan's SKU size"
}

variable "github_repo" {
  description = "Repository URL"
  default     = "https://github.com/kalyanrajsista/AzureEats-Website"
}

variable "app_settings" {
  type        = map(string)
  default     = {}
  description = "Map of App Settings."
}

variable "tags" {
  description = "The tags to associate with your azure resources."
  type        = map

  default = {
    Created_By = "devopsottawa@outlook.com"
  }
}

locals {
  os_type = "windows"
}
