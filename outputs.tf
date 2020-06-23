output "id" {
  value       = azurerm_app_service.main.id
  description = "The ID of the web app."
}

output "name" {
  value       = azurerm_app_service.main.name
  description = "The name of the web app."
}

output "hostname" {
  value       = azurerm_app_service.main.default_site_hostname
  description = "The default hostname of the web app."
}

output "url" {
  value = format("https://%s", azurerm_app_service.main.default_site_hostname)
}

output "sql_server_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) of the Azure SQL Database created."
  value       = "${azurerm_sql_server.server.fully_qualified_domain_name}"
}

output "sql_connection_string" {
  description = "Connection string for the Azure SQL Database created."
  value       = "Server=tcp:${azurerm_sql_server.server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.server.administrator_login};Password=${azurerm_sql_server.server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

output "MongoConnectionString" {
  value = azurerm_container_group.main.ip_address
}
