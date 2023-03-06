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
