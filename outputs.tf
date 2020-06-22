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
