resource "azurerm_role_assignment" "role_assignment_key_vault_msi" {
  scope                = var.cmk_key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_cognitive_account.cognitive_service.identity[0].principal_id
}
