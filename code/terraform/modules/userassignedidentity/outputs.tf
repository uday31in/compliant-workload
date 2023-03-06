output "user_assigned_identity_id" {
  value       = azurerm_user_assigned_identity.user_assigned_identity.id
  description = "Specifies the resource ID of the User Assigned Identity."
  sensitive   = false
}
