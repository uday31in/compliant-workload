output "api_management_id" {
  value       = azurerm_api_management.api_management.id
  description = "Specifies the resource ID of API Management."
  sensitive   = false
}
