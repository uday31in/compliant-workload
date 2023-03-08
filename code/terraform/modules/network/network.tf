resource "azurerm_network_security_group" "network_security_group_bastion" {
  name                = "${data.azurerm_network_security_group.network_security_group.name}-bastion"
  location            = var.location
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  tags                = var.tags

  security_rule = [
    {
      access                                     = "Allow"
      description                                = "Required for HTTPS inbound communication of connecting user."
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "443"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "AllowHttpsInbound"
      priority                                   = 120
      protocol                                   = "Tcp"
      source_address_prefix                      = "Internet"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for the control plane, that is, Gateway Manager to be able to talk to Azure Bastion."
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "443"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "AllowGatewayManagerInbound"
      priority                                   = 130
      protocol                                   = "Tcp"
      source_address_prefix                      = "GatewayManager"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for the control plane, that is, Gateway Manager to be able to talk to Azure Bastion."
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "443"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "AllowAzureLoadBalancerInbound"
      priority                                   = 140
      protocol                                   = "Tcp"
      source_address_prefix                      = "AzureLoadBalancer"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for data plane communication between the underlying components of Azure Bastion."
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = ""
      destination_port_ranges = [
        "5701",
        "8080"
      ]
      direction                             = "Inbound"
      name                                  = "AllowBastionCommunicationInbound"
      priority                              = 150
      protocol                              = "*"
      source_address_prefix                 = "VirtualNetwork"
      source_address_prefixes               = []
      source_application_security_group_ids = []
      source_port_range                     = "*"
      source_port_ranges                    = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for SSH and RDP outbound connectivity."
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = ""
      destination_port_ranges = [
        "22",
        "3389"
      ]
      direction                             = "Outbound"
      name                                  = "AllowSshRdpOutbound"
      priority                              = 100
      protocol                              = "*"
      source_address_prefix                 = "*"
      source_address_prefixes               = []
      source_application_security_group_ids = []
      source_port_range                     = "*"
      source_port_ranges                    = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for Azure Cloud outbound connectivity (Logs and Metrics)."
      destination_address_prefix                 = "AzureCloud"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "443"
      destination_port_ranges                    = []
      direction                                  = "Outbound"
      name                                       = "AllowAzureCloudOutbound"
      priority                                   = 110
      protocol                                   = "Tcp"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for data plane communication between the underlying components of Azure Bastion."
      destination_address_prefix                 = "VirtualNetwork"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = ""
      destination_port_ranges = [
        "5701",
        "8080"
      ]
      direction                             = "Outbound"
      name                                  = "AllowBastionCommunicationOutbound"
      priority                              = 120
      protocol                              = "*"
      source_address_prefix                 = "VirtualNetwork"
      source_address_prefixes               = []
      source_application_security_group_ids = []
      source_port_range                     = "*"
      source_port_ranges                    = []
    },
    {
      access                                     = "Allow"
      description                                = "Required for session and certificate validation."
      destination_address_prefix                 = "Internet"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "80"
      destination_port_ranges                    = []
      direction                                  = "Outbound"
      name                                       = "AllowGetSessionInformationOutbound"
      priority                                   = 130
      protocol                                   = "*"
      source_address_prefix                      = "*"
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    }
  ]
}

# resource "azurerm_subnet" "subnet_private_endpoints" {  # Blocked because of https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/issues/302
#   name                 = "PrivateEndpointSubnet"
#   resource_group_name  = data.azurerm_virtual_network.virtual_network.resource_group_name
#   virtual_network_name = azurerm_virtual_network.virtual_network.name

#   address_prefixes                              = [
#     tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
#   ]
#   private_endpoint_network_policies_enabled     = true
#   private_link_service_network_policies_enabled = true
# }

# resource "azurerm_subnet_network_security_group_association" "subnet_private_endpoints_nsg" {
#   subnet_id                 = azurerm_subnet.subnet_private_endpoints.id
#   network_security_group_id = data.azurerm_network_security_group.network_security_group.id
# }

# resource "azurerm_subnet_route_table_association" "subnet_private_endpoints_rt" {
#   subnet_id      = azurerm_subnet.subnet_private_endpoints.id
#   route_table_id = data.azurerm_route_table.route_table.id
# }

resource "azapi_resource" "subnet_private_endpoints" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "PrivateEndpointSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
      delegations   = []
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Disabled"
      privateLinkServiceNetworkPolicies = "Disabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })
}

resource "azapi_resource" "subnet_bastion" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "AzureBastionSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 1))
      delegations   = []
      ipAllocations = []
      networkSecurityGroup = {
        id = azurerm_network_security_group.network_security_group_bastion.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      serviceEndpointPolicies           = []
      serviceEndpoints                  = []
    }
  })
}

resource "azapi_resource" "subnet_compute" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "ComputeSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 2))
      delegations   = []
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
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
