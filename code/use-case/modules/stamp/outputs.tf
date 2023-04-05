output "open_ai_name" {
  value       = azurerm_cognitive_account.cognitive_service.name
  description = "Specifies the name of the Open AI Service."
  sensitive   = false
}

output "open_ai_endpoint" {
  value       = azurerm_cognitive_account.cognitive_service.endpoint
  description = "Specifies the endpoint of the Open AI Service."
  sensitive   = false
}

output "open_ai_model_names" {
  value       = [for model in azapi_resource.cognitive_service_open_ai_models : model.name]
  description = "Specifies the name of the Open AI Service models."
  sensitive   = false
}
