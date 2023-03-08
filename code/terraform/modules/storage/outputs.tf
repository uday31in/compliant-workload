output "storage_id" {
  value       = azurerm_storage_account.storage.id
  description = "Specifies the resource ID of the storage account."
  sensitive   = false
}
