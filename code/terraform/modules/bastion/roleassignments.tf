resource "azurerm_role_assignment" "role_assignment_key_vault" {
  scope                = var.cmk_key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.disk_encryption_set.identity.0.principal_id
}
