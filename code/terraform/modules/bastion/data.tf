data "azurerm_client_config" "current" {
}

data "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = local.cmk_uai.name
  resource_group_name = local.cmk_uai.resource_group_name
}

data "azurerm_key_vault_key" "key_vault_key" {
  name         = var.cmk_key_name
  key_vault_id = var.cmk_key_vault_id
}
