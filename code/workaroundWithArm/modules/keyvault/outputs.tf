output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id
  description = "Specifies the resource ID of the Key Vault."
  sensitive   = false
}

output "key_vault_cmk_id" {
  value       = jsondecode(azurerm_resource_group_template_deployment.key_vault_key.output_content).keyVaultKeyUri.value
  description = "Specifies the ID of the Key Vault key used for cmk."
  sensitive   = false
}

output "key_vault_cmk_name" {
  value       = jsondecode(azurerm_resource_group_template_deployment.key_vault_key.output_content).keyVaultKeyName.value
  description = "Specifies the name of the Key Vault key used for cmk."
  sensitive   = false
}
