resource "azurerm_private_dns_zone" "private_dns_zone_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_blob_vnet" {
  name                  = data.azurerm_virtual_network.virtual_network.name
  resource_group_name   = data.azurerm_virtual_network.virtual_network.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_blob.name
  virtual_network_id    = data.azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_dns_zone" "private_dns_zone_key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_key_vault_vnet" {
  name                  = data.azurerm_virtual_network.virtual_network.name
  resource_group_name   = data.azurerm_virtual_network.virtual_network.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_key_vault.name
  virtual_network_id    = data.azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_dns_zone" "private_dns_zone_cognitive_service" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_cognitive_service_vnet" {
  name                  = data.azurerm_virtual_network.virtual_network.name
  resource_group_name   = data.azurerm_virtual_network.virtual_network.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_cognitive_service.name
  virtual_network_id    = data.azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_dns_zone" "private_dns_zone_open_ai" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_open_ai_vnet" {
  name                  = data.azurerm_virtual_network.virtual_network.name
  resource_group_name   = data.azurerm_virtual_network.virtual_network.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_open_ai.name
  virtual_network_id    = data.azurerm_virtual_network.virtual_network.id
}
