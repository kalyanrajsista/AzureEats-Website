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
  default     = "poc"
}

variable "name_prefix" {
  description = "Prefix for resource names."
  default     = "terraform-lz"
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
  default     = "challenge1"
}

variable "created_by" {
  description = "Creator of these resources"
}

variable "app_service_plan_sku_tier" {
  description = "App Service plan's SKU tier"
  default     = "Standard"
}

variable "app_service_plan_sku_size" {
  description = "App Service plan's SKU size"
  default     = "S1"
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
    Created_By = "devopsottawa@outlook.com",
  }
}

variable "server_version" {
  description = "The version for the database server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  default     = "12.0"
}

variable "db_edition" {
  description = "The edition of the database to be created."
  default     = "Basic"
}

variable "collation" {
  description = "The collation for the database. Default is SQL_Latin1_General_CP1_CI_AS"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "service_objective_name" {
  description = "The performance level for the database. For the list of acceptable values, see https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-service-tiers. Default is Basic."
  default     = "Basic"
}

variable "sql_admin_username" {
  description = "The administrator username of the SQL Server."
  default     = "mradministrator"
}

variable "start_ip_address" {
  description = "Defines the start IP address used in your database firewall rule."
  default     = "0.0.0.0"
}

variable "end_ip_address" {
  description = "Defines the end IP address used in your database firewall rule."
  default     = "0.0.0.0"
}

variable "mongodb_os_type" {
  description = "OS for MongoDB container"
  default     = "linux"
}

variable "mongdb_ip_address_type" {
  description = "Address type of MongoDB"
  default     = "public"
}

locals {
  os_type = "windows"
}
