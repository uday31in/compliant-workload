resource "azapi_resource" "eventhub_namespace" {
  type = "Microsoft.EventHub/namespaces@2022-10-01-preview"
  name = "${local.prefix}-evhns001"
  parent_id = azurerm_resource_group.app_rg.id
  location = var.location
  tags                = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  body = jsonencode({
    sku = {
      name = "Premium"
      capacity = 1
      tier = "Premium"
    }
    properties = {
      disableLocalAuth = true
      encryption = {
        keySource = "Microsoft.KeyVault"
        keyVaultProperties = [
          {
            identity = {
              userAssignedIdentity = azurerm_user_assigned_identity.user_assigned_identity.id
            }
            keyName = azapi_resource.key_vault_key_eventhub.name
            keyVaultUri = azurerm_key_vault.key_vault.vault_uri
          }
        ]
        requireInfrastructureEncryption = true
      }
      kafkaEnabled = true
      minimumTlsVersion = "1.2"
      publicNetworkAccess = "Disabled"
      zoneRedundant = true
    }
  })
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_eventhub_namespace" {
  resource_id = azapi_resource.eventhub_namespace.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_eventhub_namespace" {
  name                       = "logAnalytics"
  target_resource_id         = azapi_resource.eventhub_namespace.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_eventhub_namespace.log_category_groups
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
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_eventhub_namespace.metrics
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

resource "azurerm_private_endpoint" "eventhub_namespace_private_endpoint" {
  name                = "${azapi_resource.eventhub_namespace.name}-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.app_rg.name
  tags                = var.tags

  custom_network_interface_name = "${azapi_resource.eventhub_namespace.name}-nic"
  private_service_connection {
    name                           = "${azapi_resource.eventhub_namespace.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azapi_resource.eventhub_namespace.id
    subresource_names              = ["namespace"]
  }
  subnet_id = azapi_resource.subnet_services.id
  private_dns_zone_group {
    name = "${azapi_resource.eventhub_namespace.name}-arecord"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.private_dns_zone_servicebus.id
    ]
  }
}
