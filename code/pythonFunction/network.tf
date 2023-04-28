# resource "azapi_resource" "subnet_function" {
#   type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
#   name      = "FunctionSubnet"
#   parent_id = data.azurerm_virtual_network.virtual_network.id

#   body = jsonencode({
#     properties = {
#       addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
#       delegations = [
#         {
#           name = "FunctionDelegation"
#           properties = {
#             serviceName = "Microsoft.Web/serverFarms"
#           }
#         }
#       ]
#       ipAllocations = []
#       networkSecurityGroup = {
#         id = data.azurerm_network_security_group.network_security_group.id
#       }
#       privateEndpointNetworkPolicies    = "Enabled"
#       privateLinkServiceNetworkPolicies = "Enabled"
#       routeTable = {
#         id = data.azurerm_route_table.route_table.id
#       }
#       serviceEndpointPolicies = []
#       serviceEndpoints        = []
#     }
#   })
# }

resource "azurerm_resource_group_template_deployment" "subnet_function" {
  name                = "FunctionSubnetDeployment"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  deployment_mode     = "Incremental"

  parameters_content = jsonencode({
    subnetName = {
      value = "FunctionSubnet"
    },
    subnetAddressPrefix = {
      value = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 0))
    },
    virtualNetworkId = {
      value = data.azurerm_virtual_network.virtual_network.id
    },
    networkSecurityGroupId = {
      value = data.azurerm_network_security_group.network_security_group.id
    },
    routeTableId = {
      value = data.azurerm_route_table.route_table.id
    },
    subnetDelegations = {
      value = [
        {
          name = "FunctionDelegation"
          properties = {
            serviceName = "Microsoft.Web/serverFarms"
          }
        }
      ]
    }
  })
  template_content = file("${path.module}/arm/subnet.json")
}

# resource "azapi_resource" "subnet_services" {
#   type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
#   name      = "PeSubnet"
#   parent_id = data.azurerm_virtual_network.virtual_network.id

#   body = jsonencode({
#     properties = {
#       addressPrefix = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 1))
#       delegations   = []
#       ipAllocations = []
#       networkSecurityGroup = {
#         id = data.azurerm_network_security_group.network_security_group.id
#       }
#       privateEndpointNetworkPolicies    = "Enabled"
#       privateLinkServiceNetworkPolicies = "Enabled"
#       routeTable = {
#         id = data.azurerm_route_table.route_table.id
#       }
#       serviceEndpointPolicies = []
#       serviceEndpoints        = []
#     }
#   })
# }

resource "azurerm_resource_group_template_deployment" "subnet_services" {
  name                = "PrivateEndpointSubnetDeployment"
  resource_group_name = data.azurerm_virtual_network.virtual_network.resource_group_name
  deployment_mode     = "Incremental"

  parameters_content = jsonencode({
    subnetName = {
      value = "PrivateEndpointSubnet"
    },
    subnetAddressPrefix = {
      value = tostring(cidrsubnet(data.azurerm_virtual_network.virtual_network.address_space[0], 27 - tonumber(reverse(split("/", data.azurerm_virtual_network.virtual_network.address_space[0]))[0]), 1))
    },
    virtualNetworkId = {
      value = data.azurerm_virtual_network.virtual_network.id
    },
    networkSecurityGroupId = {
      value = data.azurerm_network_security_group.network_security_group.id
    },
    routeTableId = {
      value = data.azurerm_route_table.route_table.id
    },
    subnetDelegations = {
      value = []
    }
  })
  template_content = file("${path.module}/arm/subnet.json")

  depends_on = [
    azurerm_resource_group_template_deployment.subnet_function 
  ]
}
