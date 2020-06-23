locals {
  region   = "${lower(trimspace(replace(var.location, " ", "")))}"
  location = "${lower(trimspace(replace(var.location, " ", "")))}"

  tags = var.tags
}

resource "azurerm_resource_group" "main" {
  name     = "${var.name_prefix}-${var.application}-RG"
  location = local.location

  tags = local.tags
}

#
# Get information about existing resource group
#
data "azurerm_resource_group" "main" {
  name = azurerm_resource_group.main.name
}

#
# App Service Plan for webapp
#
resource "azurerm_app_service_plan" "main" {
  name                = "${var.name_prefix}-${var.application}-${var.environment}-sp"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  kind                = local.os_type

  sku {
    tier = var.app_service_plan_sku_tier
    size = var.app_service_plan_sku_size
  }

  tags = local.tags
}

#
# Data resource for app service plan - webapp
#
data "azurerm_app_service_plan" "main" {
  name                = azurerm_app_service_plan.main.name
  resource_group_name = data.azurerm_resource_group.main.name
}

#
# Web App
#
resource "azurerm_app_service" "main" {
  name                = "${var.name_prefix}-${var.application}-${var.environment}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  app_service_plan_id = data.azurerm_app_service_plan.main.id

  site_config {
    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
      "hostingstart.html"
    ]
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "10.15.2"
    "ApiUrl"                       = "/api/v1"
    "ApiUrlShoppingCart"           = "/api/v1"
    "MongoConnectionString"        = "mongodb://${azurerm_container_group.main.ip_address}:27020"
    "SqlConnectionString"          = "Server=tcp:${azurerm_sql_server.server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.server.administrator_login};Password=${azurerm_sql_server.server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    "productImagesUrl"             = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
    "Personalizer__ApiKey"         = ""
    "Personalizer__Endpoint"       = ""
    "ASPNETCORE_DETAILEDERRORS"    = "true"
  }

  depends_on = [azurerm_container_group.main]

  tags = local.tags
}

resource "azurerm_sql_database" "db" {
  name                             = "${var.name_prefix}${var.application}sqldb"
  resource_group_name              = data.azurerm_resource_group.main.name
  location                         = data.azurerm_resource_group.main.location
  edition                          = var.db_edition
  collation                        = var.collation
  server_name                      = azurerm_sql_server.server.name
  create_mode                      = "Default"
  requested_service_objective_name = var.service_objective_name

  tags = local.tags
}

resource "azurerm_sql_server" "server" {
  name                         = "${var.name_prefix}${var.application}sqlsrvr"
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  version                      = var.server_version
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_password

  tags = local.tags
}

resource "azurerm_container_group" "main" {
  name                = "${var.name_prefix}${var.application}mongocontainer"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  ip_address_type     = var.mongdb_ip_address_type
  dns_name_label      = "${var.name_prefix}${var.application}"
  os_type             = var.mongodb_os_type

  container {
    name   = "mongodb"
    image  = "mongo:latest"
    cpu    = 1
    memory = 2

    ports {
      port     = 27017
      protocol = "TCP"
    }
  }
}

resource "azurerm_sql_firewall_rule" "fw" {
  name                = "${var.name_prefix}${var.application}fwrules"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_sql_server.server.name
  start_ip_address    = var.start_ip_address
  end_ip_address      = var.end_ip_address
}

resource "null_resource" "configure-git" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "powershell.exe -File ${path.cwd}/config-github.ps1 -SubscriptionId ${var.azurerm_subscription_id} -AppId ${var.azurerm_client_id} -Password \"${var.azurerm_client_secret}\" -TenantId ${var.azurerm_tenant_id} -AppServiceName ${azurerm_app_service.main.name} -ResourceGroupName ${data.azurerm_resource_group.main.name} -GitHubRepo ${var.github_repo}"
  }
}
