resource "azurerm_key_vault" "key_vault" {
  name                = "${local.prefix}-vault001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  access_policy                   = []
  enable_rbac_authorization       = true
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.ip_rules_key_vault
    virtual_network_subnet_ids = []
  }
  public_network_access_enabled = true # TODO: Update when ExpressRoute is available
  purge_protection_enabled      = true
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

resource "azapi_resource" "key_vault_key_storage" {
  type      = "Microsoft.KeyVault/vaults/keys@2022-11-01"
  name      = "cmkStorage"
  parent_id = azurerm_key_vault.key_vault.id

  body = jsonencode({
    properties = {
      attributes = {
        enabled    = true
        exp        = 1709484065
        exportable = false
      }
      curveName = "P-256"
      keyOps = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      keySize = 2048
      kty     = "RSA"
    }
  })
  response_export_values = ["properties.keyUriWithVersion"]
}

resource "azapi_resource" "key_vault_key_cognitive_services" {
  type      = "Microsoft.KeyVault/vaults/keys@2022-11-01"
  name      = "cmkCognitiveService"
  parent_id = azurerm_key_vault.key_vault.id

  body = jsonencode({
    properties = {
      attributes = {
        enabled    = true
        exp        = 1709484065
        exportable = false
      }
      curveName = "P-256"
      keyOps = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      keySize = 2048
      kty     = "RSA"
    }
  })
  response_export_values = ["properties.keyUriWithVersion"]
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_key_vault" {
  resource_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_key_vault" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_key_vault.key_vault.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault.log_category_groups
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
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault.metrics
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

# resource "azurerm_private_endpoint" "key_vault_private_endpoint" {  # Uncomment to deploy the private endpoint
#   name                = "${azurerm_key_vault.key_vault.name}-pe"
#   location            = var.location
#   resource_group_name = azurerm_key_vault.key_vault.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azurerm_key_vault.key_vault.name}-nic"
#   private_service_connection {
#     name                           = "${azurerm_key_vault.key_vault.name}-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_key_vault.key_vault.id
#     subresource_names              = ["vault"]
#   }
#   subnet_id = var.subnet_id
#   dynamic "private_dns_zone_group" {
#     for_each = var.private_dns_zone_id_key_vault == "" ? [] : [1]
#     content {
#       name = "${azurerm_key_vault.key_vault.name}-arecord"
#       private_dns_zone_ids = [
#         var.private_dns_zone_id_key_vault
#       ]
#     }
#   }
# }
