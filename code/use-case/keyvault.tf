resource "azurerm_key_vault" "key_vault" {
  name                = "${local.prefix}-vault001"
  location            = var.location
  resource_group_name = azurerm_resource_group.ingress_rg.name
  tags                = var.tags

  access_policy                   = []
  enable_rbac_authorization       = true
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = local.proxy_ips
    virtual_network_subnet_ids = []
  }
  public_network_access_enabled = true
  purge_protection_enabled      = true
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_key_vault" {
  resource_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_key_vault" {
  name                           = "logAnalytics"
  target_resource_id             = azurerm_key_vault.key_vault.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace.id

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

# resource "azurerm_key_vault_certificate" "key_vault_certificate" {  # Uncomment to deploy certificate to key vault
#   name                = "ApimCertificate"
#   key_vault_id = azurerm_key_vault.key_vault.id

#   certificate_policy {
#     issuer_parameters {
#       name = "Self"
#     }
#     key_properties {
#       exportable = true
#       key_size   = 2048
#       key_type   = "RSA"
#       reuse_key  = true
#     }
#     lifetime_action {
#       action {
#         action_type = "AutoRenew"
#       }

#       trigger {
#         days_before_expiry = 30
#       }
#     }
#     secret_properties {
#       content_type = "application/x-pkcs12"
#     }
#     x509_certificate_properties {
#       # Server Authentication = 1.3.6.1.5.5.7.3.1
#       # Client Authentication = 1.3.6.1.5.5.7.3.2
#       extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

#       key_usage = [
#         "cRLSign",
#         "dataEncipherment",
#         "digitalSignature",
#         "keyAgreement",
#         "keyCertSign",
#         "keyEncipherment",
#       ]

#       subject_alternative_names {
#         dns_names = ["internal.contoso.com", "domain.hello.world"]
#       }

#       subject            = "CN=hello-world"
#       validity_in_months = 12
#     }
#   }
# }
