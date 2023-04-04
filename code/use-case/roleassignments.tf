resource "azurerm_role_assignment" "role_assignment_key_vault_apim" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_api_management.api_management.identity[0].principal_id
}

# resource "azurerm_role_assignment" "role_assignment_key_vault_current" {
#   scope                = azurerm_key_vault.key_vault.id
#   role_definition_name = "Key Vault Certificates Officer"
#   principal_id         = data.azurerm_client_config.current.object_id
# }
