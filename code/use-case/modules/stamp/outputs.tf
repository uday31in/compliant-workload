output "open_ai_endpoint" {
  value       = azurerm_cognitive_account.cognitive_service.endpoint
  description = "Specifies the endpoint of the Open AI Service."
  sensitive   = false
}
