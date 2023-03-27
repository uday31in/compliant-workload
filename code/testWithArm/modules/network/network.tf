# resource "azapi_resource" "subnet_private_endpoints" {
#   type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
#   name      = "PrivateEndpointSubnet"
#   parent_id = data.azurerm_virtual_network.virtual_network.id

#   body = jsonencode({
#     properties = {
#       addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
#       delegations   = []
#       ipAllocations = []
#       networkSecurityGroup = {
#         id = data.azurerm_network_security_group.network_security_group.id
#       }
#       privateEndpointNetworkPolicies    = "Disabled"
#       privateLinkServiceNetworkPolicies = "Disabled"
#       routeTable = {
#         id = data.azurerm_route_table.route_table.id
#       }
#       serviceEndpointPolicies = []
#       serviceEndpoints        = []
#     }
#   })
# }

resource "azurerm_resource_group_template_deployment" "subnet_private_endpoints" {
  name = "PrivateEndpointSubnet"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  deployment_mode = "Incremental"

  parameters_content = jsonencode({
    subnetName = {
      value = "PrivateEndpointSubnet"
    },
    subnetAddressPrefix = {
      value = "192.168.3.0/24" # tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
    },
    virtualNetworkId = {
      value = data.azurerm_virtual_network.virtual_network.id
    },
    networkSecurityGroupId = {
      value = data.azurerm_network_security_group.network_security_group.id
    },
    routeTableId = {
      value = data.azurerm_route_table.route_table.id
    }
  })
  template_content = file("${path.module}/subnet.json")
}
