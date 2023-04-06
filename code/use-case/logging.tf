resource "azurerm_application_insights" "application_insights" {
  name                = "${local.prefix}-appi001"
  location            = var.location
  resource_group_name = azurerm_resource_group.logging_rg.name
  tags                = var.tags

  application_type                      = "other"
  daily_data_cap_notifications_disabled = false
  disable_ip_masking                    = false
  force_customer_storage_for_profiler   = false
  internet_ingestion_enabled            = true
  internet_query_enabled                = true
  local_authentication_disabled         = true
  retention_in_days                     = 90
  sampling_percentage                   = 100
  workspace_id                          = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${local.prefix}-log001"
  location            = var.location
  resource_group_name = azurerm_resource_group.logging_rg.name
  tags                = var.tags

  allow_resource_only_permissions = true
  cmk_for_query_forced            = false
  daily_quota_gb                  = -1
  internet_ingestion_enabled      = true
  internet_query_enabled          = true
  local_authentication_disabled   = true
  retention_in_days               = 30
  sku                             = "PerGB2018"
}

resource "azurerm_monitor_private_link_scope" "mpls" {
  name                = "${local.prefix}-ampls001"
  resource_group_name = azurerm_resource_group.logging_rg.name
  tags                = var.tags
}

resource "azurerm_monitor_private_link_scoped_service" "mpls_application_insights" {
  name                = "ampls-${azurerm_application_insights.application_insights.name}"
  resource_group_name = azurerm_monitor_private_link_scope.mpls.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.mpls.name
  linked_resource_id  = azurerm_application_insights.application_insights.id
}

resource "azurerm_monitor_private_link_scoped_service" "mpls_log_analytics_workspace" {
  name                = "ampls-${azurerm_log_analytics_workspace.log_analytics_workspace.name}"
  resource_group_name = azurerm_monitor_private_link_scope.mpls.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.mpls.name
  linked_resource_id  = azurerm_log_analytics_workspace.log_analytics_workspace.id
}
