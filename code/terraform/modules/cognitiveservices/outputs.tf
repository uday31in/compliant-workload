output "cognitive_service_id" {
  value       = azurerm_cognitive_account.cognitive_service.id
  description = "Specifies the resource ID of the Cognitive Service."
  sensitive   = false
}
