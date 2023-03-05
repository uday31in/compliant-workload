# module "network" {
#   source = "./modules/network"

#   location                    = var.location
#   tags                        = var.tags
#   network_security_group_name = "${local.prefix}-nsg001"
#   resource_group_name         = azurerm_resource_group.network_rg.name
#   route_table_name            = "${local.prefix}-rt001"
#   virtual_network_name        = "${local.prefix}-vnet001"
#   ddos_protection_plan_id     = var.ddos_protection_plan_id
# }

module "key_vault" {
  source = "./modules/keyvault"

  location                      = var.location
  tags                          = var.tags
  resource_group_name           = azurerm_resource_group.services_rg.name
  key_vault_name                = "${local.prefix}-vault001"
  subnet_id                     = module.network.subnet_private_endpoints_id
  private_dns_zone_id_key_vault = var.private_dns_zone_id_key_vault
}
