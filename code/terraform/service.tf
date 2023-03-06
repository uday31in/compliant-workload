module "network" {
  source = "./modules/network"

  location       = var.location
  tags           = var.tags
  vnet_id        = var.vnet_id
  nsg_id         = var.nsg_id
  route_table_id = var.route_table_id
}

module "user_assigned_identity" {
  source = "./modules/userassignedidentity"
  
  location                      = var.location
  tags                          = var.tags
  resource_group_name           = azurerm_resource_group.services_rg.name
  user_assigned_identity_name = "${local.prefix}-uai001"
}

# module "key_vault" {
#   source = "./modules/keyvault"

#   location                      = var.location
#   tags                          = var.tags
#   resource_group_name           = azurerm_resource_group.services_rg.name
#   key_vault_name                = "${local.prefix}-vault001"
#   subnet_id                     = module.network.subnet_private_endpoints_id
#   private_dns_zone_id_key_vault = var.private_dns_zone_id_key_vault
# }

module "cognitive_service" {
  source = "./modules/cognitiveservices"

  location                              = var.location
  tags                                  = var.tags
  resource_group_name                   = azurerm_resource_group.services_rg.name
  cognitive_service_name                = "${local.prefix}-cog001"
  cognitive_service_kind                = "CognitiveServices"
  cognitive_service_sku                 = "S0"
  subnet_id                             = module.network.subnet_private_endpoints_id
  private_dns_zone_id_cognitive_service = var.private_dns_zone_id_cognitive_service
  cmk_uai_id                            = module.user_assigned_identity.user_assigned_identity_id
  cmk_key_id                            = var.cmk_key_id
}
