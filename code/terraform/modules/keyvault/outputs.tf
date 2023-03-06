output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id
  description = "Specifies the resource ID of the Key Vault."
  sensitive   = false
}

output "key_vault_cmk_id" {
  value = azurerm_key_vault_key.key_vault_key.id
}
