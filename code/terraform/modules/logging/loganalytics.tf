resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  allow_resource_only_permissions = true
  cmk_for_query_forced            = false
  daily_quota_gb                  = -1
  internet_ingestion_enabled      = true
  internet_query_enabled          = true
  local_authentication_disabled   = true
  # reservation_capacity_in_gb_per_day = 100
  retention_in_days = 30
  sku               = "PerGB2018"
}
