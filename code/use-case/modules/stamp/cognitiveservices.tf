resource "azurerm_cognitive_account" "cognitive_service" {
  name                = "${local.prefix}-cog001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  custom_subdomain_name = "${local.prefix}-cog001"
  customer_managed_key { # Request first via https://forms.office.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR3k4-f_9d9xPhWkgOUub9YhUNDZJUERRVVVDME4xNDVNRjEwMTNZV1dHSS4u
    key_vault_key_id = jsondecode(azapi_resource.key_vault_key_cognitive_services.output).properties.keyUriWithVersion
  }
  dynamic_throttling_enabled = false
  fqdns = [
    trimsuffix(replace(azurerm_storage_account.storage.primary_blob_endpoint, "https://", ""), "/"),
    trimsuffix(replace(azurerm_key_vault.key_vault.vault_uri, "https://", ""), "/")
  ]
  kind               = "OpenAI"
  local_auth_enabled = false
  network_acls {
    default_action = "Deny"
    ip_rules       = var.ip_rules_cognitive_service
  }
  outbound_network_access_restricted = true
  public_network_access_enabled      = true # TODO: Update when ExpressRoute is available
  sku_name                           = "S0"

  depends_on = [
    azurerm_role_assignment.role_assignment_key_vault_uai
  ]
}

resource "azapi_resource" "cognitive_service_open_ai_models" {
  for_each  = { for each in var.cognitive_service_openai_models : "${each.name}-${each.version}" => each }
  type      = "Microsoft.CognitiveServices/accounts/deployments@2022-12-01"
  name      = each.key
  parent_id = azurerm_cognitive_account.cognitive_service.id

  body = jsonencode({
    properties = {
      model = {
        format  = each.value.format
        name    = each.value.name
        version = each.value.version
      }
      scaleSettings = {
        scaleType = "Standard"
      }
    }
  })
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_cognitive_service" {
  resource_id = azurerm_cognitive_account.cognitive_service.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_cognitive_service" {
  name                       = "logAnalytics"
  target_resource_id         = azurerm_cognitive_account.cognitive_service.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_service.log_category_groups
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
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_cognitive_service.metrics
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

# resource "azurerm_private_endpoint" "cognitive_service_private_endpoint" {  # Uncomment to deploy the private endpoint
#   name                = "${azurerm_cognitive_account.cognitive_service.name}-pe"
#   location            = var.location
#   resource_group_name = azurerm_cognitive_account.cognitive_service.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azurerm_cognitive_account.cognitive_service.name}-nic"
#   private_service_connection {
#     name                           = "${azurerm_cognitive_account.cognitive_service.name}-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_cognitive_account.cognitive_service.id
#     subresource_names              = ["account"]
#   }
#   subnet_id = var.subnet_id
#   dynamic "private_dns_zone_group" {
#     for_each = var.private_dns_zone_id_open_ai == "" ? [] : [1]
#     content {
#       name = "${azurerm_cognitive_account.cognitive_service.name}-arecord"
#       private_dns_zone_ids = [
#         var.private_dns_zone_id_open_ai
#       ]
#     }
#   }
# }
