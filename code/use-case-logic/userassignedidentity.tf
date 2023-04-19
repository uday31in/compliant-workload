resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = "${local.prefix}-uai001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
