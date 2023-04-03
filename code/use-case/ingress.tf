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
    ip_rules                   = setunion(local.proxy_ips, local.apim_ips)
    virtual_network_subnet_ids = []
  }
  public_network_access_enabled = true
  purge_protection_enabled      = true
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_key_vault_certificate" "key_vault_certificate" {
  name                = "ApimCertificate"
  key_vault_id = azurerm_key_vault.key_vault.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }
    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }
    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }
    secret_properties {
      content_type = "application/x-pkcs12"
    }
    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["internal.contoso.com", "domain.hello.world"]
      }

      subject            = "CN=hello-world"
      validity_in_months = 12
    }
  }
}

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
