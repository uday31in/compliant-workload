output "virtual_network_id" {
  value       = azurerm_virtual_network.virtual_network.id
  description = "Specifies the resource ID of the Virtual Network."
  sensitive   = false
}

output "nsg_id" {
  value       = azurerm_network_security_group.network_security_group.id
  description = "Specifies the resource ID of the Network Security Group."
  sensitive   = false
}

output "rt_id" {
  value       = azurerm_route_table.route_table.id
  description = "Specifies the resource ID of the Route Table."
  sensitive   = false
}

output "subnet_private_endpoints_id" {
  value       = azurerm_subnet.subnet_private_endpoints.id
  description = "Specifies the resource ID of the Private Endpoint subnet."
  sensitive   = false
}
