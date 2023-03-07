resource "azurerm_public_ip" "public_ip" {
  name                = "${var.bastion_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  domain_name_label       = "${var.bastion_name}-pip"
  idle_timeout_in_minutes = 4
  ip_version              = "IPv4"
  sku                     = "Standard"
  sku_tier                = "Regional"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  copy_paste_enabled = true
  file_copy_enabled  = true
  ip_configuration {
    name                 = "ipConfiguration"
    public_ip_address_id = azurerm_public_ip.public_ip.id
    subnet_id            = var.subnet_bastion_id
  }
  ip_connect_enabled     = true
  scale_units            = 2
  shareable_link_enabled = true
  sku                    = "Standard"
  tunneling_enabled      = true
}
