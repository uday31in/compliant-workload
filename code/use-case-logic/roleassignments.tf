resource "azurerm_role_assignment" "role_assignment_key_vault_uai" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

# resource "azurerm_role_assignment" "role_assignment_key_vault_apim" {
#   scope                = azurerm_key_vault.key_vault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_api_management.api_management.identity[0].principal_id
# }
