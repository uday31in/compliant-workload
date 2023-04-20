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

  app_service_plan_id     = azurerm_service_plan.service_plan.id
  app_settings            = {}
  bundle_version          = "[1.*, 2.0.0)"
  client_affinity_enabled = false
  client_certificate_mode = "Optional"
  enabled                 = true
  https_only              = true
  site_config {
    always_on                = false
    app_scale_limit          = 0
    elastic_instance_minimum = 1
    ftps_state               = "FtpsOnly"
    http2_enabled            = false
    min_tls_version          = "1.2"
    # pre_warmed_instance_count = 0
    runtime_scale_monitoring_enabled = false
    # scm_ip_restriction = []
    scm_min_tls_version         = "1.2"
    scm_type                    = "None"
    scm_use_main_ip_restriction = true
    use_32_bit_worker_process   = true
    vnet_route_all_enabled      = true
    websockets_enabled          = false
  }
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  storage_account_share_name = azapi_resource.storage_file_share.name
  use_extension_bundle       = true
  version                    = "~3"
  virtual_network_subnet_id  = azapi_resource.subnet_logicapp.id
}
