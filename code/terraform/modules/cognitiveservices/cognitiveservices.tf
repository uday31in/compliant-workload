resource "azurerm_cognitive_account" "cognitive_service" {
  name                = var.cognitive_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.user_assigned_identity.id
    ]
  }

  custom_subdomain_name = var.cognitive_service_name
  customer_managed_key {
    identity_client_id = data.azurerm_user_assigned_identity.user_assigned_identity.client_id
    key_vault_key_id   = var.cmk_key_id
  }
  dynamic_throttling_enabled = true
  fqdns                      = []
  kind                       = var.cognitive_service_kind
  local_auth_enabled         = false
  network_acls {
    default_action = "Deny"
    ip_rules       = []
  }
  outbound_network_access_restricted = true
  public_network_access_enabled      = false
  sku_name                           = var.cognitive_service_sku
}

resource "azurerm_private_endpoint" "cognitive_service_private_endpoint" {
  name                = "${azurerm_cognitive_account.cognitive_service.name}-pe"
  location            = var.location
  resource_group_name = azurerm_cognitive_account.cognitive_service.resource_group_name
  tags                = var.tags

  custom_network_interface_name = "${azurerm_cognitive_account.cognitive_service.name}-nic"
  private_service_connection {
    name                           = "${azurerm_cognitive_account.cognitive_service.name}-pe"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.cognitive_service.id
    subresource_names              = ["vault"]
  }
  subnet_id = var.subnet_id
  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id_cognitive_service == "" ? [] : [1]
    content {
      name = "${azurerm_cognitive_account.cognitive_service.name}-arecord"
      private_dns_zone_ids = [
        var.private_dns_zone_id_cognitive_service
      ]
    }
  }
}
