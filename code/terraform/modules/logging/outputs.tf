output "application_insights_id" {
  value       = azurerm_application_insights.application_insights.app_id
  description = "Specifies the resource ID of Application Insights."
  sensitive   = false
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
  description = "Specifies the resource ID of the Log Analytics Workspace."
  sensitive   = false
}
