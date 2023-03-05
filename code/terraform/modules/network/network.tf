resource "azurerm_network_security_group" "network_security_group" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule = []
}

resource "azurerm_route_table" "route_table" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  disable_bgp_route_propagation = false
  route                         = []
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  address_space = ["10.0.0.0/24"]
  dns_servers   = []
  ddos_protection_plan {
    enable = true
    id     = var.ddos_protection_plan_id
  }
}

resource "azurerm_subnet" "subnet_private_endpoints" {
  name                 = "PrivateEndpointSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name

  address_prefixes                              = ["10.0.0.0/27"]
  private_endpoint_network_policies_enabled     = true
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet_network_security_group_association" "subnet_private_endpoints_nsg" {
  subnet_id                 = azurerm_subnet.subnet_private_endpoints.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "azurerm_subnet_route_table_association" "subnet_private_endpoints_rt" {
  subnet_id      = azurerm_subnet.subnet_private_endpoints.id
  route_table_id = azurerm_route_table.route_table.id
}
