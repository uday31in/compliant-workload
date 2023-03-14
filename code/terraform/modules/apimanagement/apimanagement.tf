resource "azurerm_api_management" "api_management" {
  name                = var.api_management_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  dynamic "certificate" {
    for_each = var.encoded_certificate == "" ? [] : [1]
    content {
      encoded_certificate = var.encoded_certificate
      store_name          = "certificate-store"
    }
  }
  client_certificate_enabled = false
  gateway_disabled           = false
  min_api_version            = "2021-08-01"
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
  virtual_network_configuration {
    subnet_id = var.subnet_id
  }
  virtual_network_type = "Internal"
  zones                = var.api_management_sku == "Premium" ? ["1", "2", "3"] : null
}
