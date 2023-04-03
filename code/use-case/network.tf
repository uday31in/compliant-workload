resource "azurerm_network_security_group" "network_security_group_apim" {
  name                = "${data.azurerm_network_security_group.network_security_group.name}-apim"
  location            = var.location
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags

  security_rule = [
    {
      access                                     = "Allow"
      description                                = "Required for control plane traffic for API Management."
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "3443"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "AllowApiManagementInbound"
      priority                                   = 100
      protocol                                   = "Tcp"
      source_address_prefix                      = "ApiManagement"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for Azure infrastructure Load Balancer for API management."
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "6390"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "AllowHttpsInbound"
      priority                                   = 110
      protocol                                   = "Tcp"
      source_address_prefix                      = "AzureLoadBalancer"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for Storage dependency of API management."
      destination_address_prefix                 = "Storage"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "443"
      destination_port_ranges                    = []
      direction                                  = "Outbound"
      name                                       = "AllowStorageOutbound"
      priority                                   = 120
      protocol                                   = "Tcp"
      source_address_prefix                      = "VirtualNetwork"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for SQL dependency of API management."
      destination_address_prefix                 = "SQL"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "1433"
      destination_port_ranges                    = []
      direction                                  = "Outbound"
      name                                       = "AllowSqlOutbound"
      priority                                   = 130
      protocol                                   = "Tcp"
      source_address_prefix                      = "VirtualNetwork"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for Key Vault dependency of API management."
      destination_address_prefix                 = "AzureKeyVault"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "443"
      destination_port_ranges                    = []
      direction                                  = "Outbound"
      name                                       = "AllowKeyVaultOutbound"
      priority                                   = 140
      protocol                                   = "Tcp"
      source_address_prefix                      = "VirtualNetwork"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    }
  ]
}

resource "azapi_resource" "subnet_appgw" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "ApimSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
      delegations   = []
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      serviceEndpointPolicies           = []
      serviceEndpoints                  = []
    }
  })
}

resource "azapi_resource" "subnet_apim" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "ApimSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 1))
      delegations   = []
      ipAllocations = []
      networkSecurityGroup = {
        id = azurerm_network_security_group.network_security_group_apim.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })
}

resource "azapi_resource" "subnet_stamps" {
  for_each  = toset(var.stamps)
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "${title(each.key)}Subnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 29 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 8 + index(var.stamps, each.key)))
      delegations   = []
      ipAllocations = []
      networkSecurityGroup = {
        id = azurerm_network_security_group.network_security_group_apim.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })
}
