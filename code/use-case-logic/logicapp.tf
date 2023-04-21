resource "azurerm_service_plan" "service_plan" {
  name                = "${local.prefix}-asp001"
  location            = var.location
  resource_group_name = azurerm_resource_group.app_rg.name
  tags                = var.tags

  maximum_elastic_worker_count = 20
  os_type                      = "Windows"
  per_site_scaling_enabled     = false
  sku_name                     = "WS1"
  worker_count                 = 3
  zone_balancing_enabled       = true
}

resource "azurerm_logic_app_standard" "logic_app_standard" {
  name                = "${local.prefix}-logic001"
  location            = var.location
  resource_group_name = azurerm_resource_group.app_rg.name
  tags                = var.tags
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  app_service_plan_id = azurerm_service_plan.service_plan.id
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.application_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.application_insights.connection_string
    "FUNCTIONS_WORKER_RUNTIME"              = "node"
    "WEBSITE_NODE_DEFAULT_VERSION"          = "~18"
    "WEBSITE_CONTENTOVERVNET"               = "1"
    "WEBSITE_VNET_ROUTE_ALL"                = "1"
  }
  bundle_version          = "[1.*, 2.0.0)"
  client_affinity_enabled = false
  client_certificate_mode = "Optional"
  enabled                 = true
  https_only              = true
  site_config {
    always_on                = false
    app_scale_limit          = 0
    elastic_instance_minimum = 3
    ftps_state               = "FtpsOnly"
    http2_enabled            = false
    ip_restriction = [
      {
        name                      = "AllowSentinel"
        action                    = "Allow"
        headers                   = null
        ip_address                = null
        priority                  = 100
        service_tag               = "AzureSentinel"
        virtual_network_subnet_id = null
      }
    ]
    min_tls_version = "1.2"
    # pre_warmed_instance_count = 0  # Uncomment to configure pre-warmed instance count
    runtime_scale_monitoring_enabled = false
    # scm_ip_restriction = []  # Uncomment to define IP restrictions for SCM endpoint
    scm_min_tls_version         = "1.2"
    scm_type                    = "None"
    scm_use_main_ip_restriction = false
    use_32_bit_worker_process   = true
    vnet_route_all_enabled      = true
    websockets_enabled          = false
  }
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  storage_account_share_name = azapi_resource.storage_file_share.name
  use_extension_bundle       = true
  version                    = "~4"
  virtual_network_subnet_id  = azapi_resource.subnet_logicapp.id
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_service_plan" {
  resource_id = azurerm_service_plan.service_plan.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_service_plan" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_service_plan.service_plan.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_service_plan.log_category_groups
    content {
      category_group = entry.value
      retention_policy {
        enabled = true
        days    = 30
      }
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_service_plan.metrics
    content {
      category = entry.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = 30
      }
    }
  }
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_logic_app_standard" {
  resource_id = azurerm_logic_app_standard.logic_app_standard.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_logic_app_standard" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_logic_app_standard.logic_app_standard.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_logic_app_standard.log_category_groups
    content {
      category_group = entry.value
      retention_policy {
        enabled = true
        days    = 30
      }
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_logic_app_standard.metrics
    content {
      category = entry.value
      enabled  = true
      retention_policy {
        enabled = true
        days    = 30
      }
    }
  }
}
