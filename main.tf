locals {
  region   = "${lower(trimspace(replace(var.location, " ", "")))}"
  location = "${lower(trimspace(replace(var.location, " ", "")))}"

  tags = var.tags
}

resource "azurerm_resource_group" "main" {
  name     = "${var.name_prefix}-${var.application}-RG"
  location = local.location
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
    "ApiUrl"                       = "https://backend.tailwindtraders.com/webbff/v1"
    "ApiUrlShoppingCart"           = "https://backend.tailwindtraders.com/cart-api"
    "productImagesUrl"             = "https://raw.githubusercontent.com/microsoft/TailwindTraders-Backend/master/Deploy/tailwindtraders-images/product-detail"
  }

  tags = local.tags
}

resource "null_resource" "configure-git" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "powershell.exe -File ${path.cwd}/config-github.ps1 -SubscriptionId ${var.azurerm_subscription_id} -AppId ${var.azurerm_client_id} -Password \"${var.azurerm_client_secret}\" -TenantId ${var.azurerm_tenant_id} -AppServiceName ${azurerm_app_service.main.name} -ResourceGroupName ${data.azurerm_resource_group.main.name} -GitHubRepo ${var.github_repo}"
  }
}
