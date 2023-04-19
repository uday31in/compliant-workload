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

resource "azurerm_private_dns_zone" "private_dns_zone_queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_queue_vnet" {
  name                  = data.azurerm_virtual_network.virtual_network.name
  resource_group_name   = data.azurerm_virtual_network.virtual_network.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_queue.name
  virtual_network_id    = data.azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_dns_zone" "private_dns_zone_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_file_vnet" {
  name                  = data.azurerm_virtual_network.virtual_network.name
  resource_group_name   = data.azurerm_virtual_network.virtual_network.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_file.name
  virtual_network_id    = data.azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_dns_zone" "private_dns_zone_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_table_vnet" {
  name                  = data.azurerm_virtual_network.virtual_network.name
  resource_group_name   = data.azurerm_virtual_network.virtual_network.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_table.name
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
