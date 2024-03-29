module "stamps" {
  source   = "./modules/stamp"
  for_each = toset(var.stamps)

  location                   = var.location
  resource_group_name        = azurerm_resource_group.stamp_rgs[each.key].name
  prefix                     = local.prefix
  stamp                      = each.key
  tags                       = var.tags
  subnet_id                  = azapi_resource.subnet_stamps[each.key].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  storage_container_names = [
    "data"
  ]
  cognitive_service_openai_models = [
    {
      format  = "OpenAI"
      name    = "gpt-35-turbo"
      version = "0301"
    }
  ]
  ip_rules_cognitive_service    = setunion(local.proxy_ips, local.apim_ips)
  ip_rules_storage              = setunion(local.proxy_ips, local.open_ai_ips_eastus)
  ip_rules_key_vault            = local.proxy_ips
  private_dns_zone_id_key_vault = azurerm_private_dns_zone.private_dns_zone_key_vault.id
  private_dns_zone_id_open_ai   = azurerm_private_dns_zone.private_dns_zone_open_ai.id
  private_dns_zone_id_blob      = azurerm_private_dns_zone.private_dns_zone_blob.id
  private_dns_zone_id_dfs       = azurerm_private_dns_zone.private_dns_zone_dfs.id
}
