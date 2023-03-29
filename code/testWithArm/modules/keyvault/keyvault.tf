resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
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
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  public_network_access_enabled = false
  purge_protection_enabled      = true
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

# resource "azurerm_key_vault_key" "key_vault_key" {  # Requires access to dataplane
#   name         = "cmk"
#   key_vault_id = azurerm_key_vault.key_vault.id

#   key_type = "RSA"
#   key_size = 2048
#   key_opts = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

#   depends_on = [
#     azurerm_role_assignment.role_assignment_key_vault_current
#   ]
# }

resource "azapi_resource" "key_vault_key" {
  type      = "Microsoft.KeyVault/vaults/keys@2022-11-01"
  name      = "cmk"
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
}

resource "azurerm_resource_group_template_deployment" "key_vault_key" {
  name = "KeyVaultKey"
  resource_group_name = azurerm_key_vault.key_vault.resource_group_name
  deployment_mode = "Incremental"

  parameters_content = jsonencode({
    keyVaultKeyName = {
      value = "MyCmk"
    },
    keyVaultId = {
      value = azurerm_key_vault.key_vault.id
    }
  })
  template_content = file("${path.module}/keyVaultKey.json")
}

# resource "azurerm_private_endpoint" "key_vault_private_endpoint" {
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
