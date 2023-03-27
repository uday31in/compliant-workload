module "network" {
  source = "./modules/network"

  location       = var.location
  tags           = var.tags
  vnet_id        = var.vnet_id
  nsg_id         = var.nsg_id
  route_table_id = var.route_table_id
}

module "key_vault" {
  source = "./modules/keyvault"

  location                      = var.location
  tags                          = var.tags
  resource_group_name           = azurerm_resource_group.services_rg.name
  key_vault_name                = "${local.prefix}-vault001"
  # cmk_uai_id                    = module.user_assigned_identity.user_assigned_identity_id
  subnet_id                     = module.network.subnet_private_endpoints_id
  private_dns_zone_id_key_vault = module.network.private_dns_zone_key_vault_id
}
