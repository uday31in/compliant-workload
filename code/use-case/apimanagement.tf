resource "azurerm_api_management" "api_management" {
  name                = "${local.prefix}-apim001"
  location            = var.location
  resource_group_name = azurerm_resource_group.ingress_rg.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  client_certificate_enabled = false
  gateway_disabled           = false
  min_api_version            = "2019-12-01"
  notification_sender_email  = var.api_management_email
  protocols {
    enable_http2 = true
  }
  public_network_access_enabled = true
  publisher_email               = var.api_management_email
  publisher_name                = var.publisher_name
  security {
    enable_backend_ssl30                                = true
    enable_backend_tls10                                = false
    enable_backend_tls11                                = false
    enable_frontend_ssl30                               = true
    enable_frontend_tls10                               = false
    enable_frontend_tls11                               = false
    tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = true
    tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = true
    tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled   = false
    tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled   = false
    tls_rsa_with_aes128_cbc_sha256_ciphers_enabled      = false
    tls_rsa_with_aes128_cbc_sha_ciphers_enabled         = false
    tls_rsa_with_aes128_gcm_sha256_ciphers_enabled      = false
    tls_rsa_with_aes256_cbc_sha256_ciphers_enabled      = false
    tls_rsa_with_aes256_cbc_sha_ciphers_enabled         = false
    tls_rsa_with_aes256_gcm_sha384_ciphers_enabled      = true
    triple_des_ciphers_enabled                          = false
  }
  sign_in {
    enabled = true
  }
  sign_up {
    enabled = true
    terms_of_service {
      consent_required = true
      enabled          = true
      text             = "Terms of Service."
    }
  }
  sku_name = "${var.api_management_sku}_${var.api_management_capacity}"
  tenant_access {
    enabled = false
  }
  #   virtual_network_configuration {
  #     subnet_id = azapi_resource.subnet_apim.id
  #   }
  virtual_network_type = "None"
  zones                = var.api_management_sku == "Premium" ? ["1", "2", "3"] : null
}

# resource "azurerm_api_management_certificate" "api_management_certificate" {  # Uncomment to deploy certificates to APIM
#   name                = "ApimCertificate"
#   api_management_name = azurerm_api_management.api_management.name
#   resource_group_name = azurerm_api_management.api_management.resource_group_name

#   key_vault_secret_id = azurerm_key_vault_certificate.key_vault_certificate.secret_id

#   depends_on = [
#     azurerm_role_assignment.role_assignment_key_vault_apim
#   ]
# }

# resource "azurerm_api_management_policy" "api_management_policy_openai" {  # Uncomment to deploy policies to APIM 
#   api_management_id = azurerm_api_management.example.id
#   xml_content       = file("${path.module}/apim_policy/openai_policy.xml")
# }

resource "azurerm_api_management_logger" "api_management_logger" {
  name                = "application-insights"
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = azurerm_api_management.api_management.resource_group_name
  resource_id         = azurerm_application_insights.application_insights.id

  application_insights {
    instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
  }
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_api_management" {
  resource_id = azurerm_api_management.api_management.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_api_management" {
  name                           = "logAnalytics"
  target_resource_id             = azurerm_api_management.api_management.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.log_analytics_workspace.id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_api_management.log_category_groups
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
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_api_management.metrics
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
