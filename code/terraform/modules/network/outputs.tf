output "subnet_private_endpoints_id" {
  value       = azapi_resource.subnet_private_endpoints.id
  description = "Specifies the resource ID of the Private Endpoint subnet."
  sensitive   = false
}

output "subnet_bastion_id" {
  value       = azapi_resource.subnet_bastion.id
  description = "Specifies the resource ID of the Bastion subnet."
  sensitive   = false
}

output "subnet_compute_id" {
  value       = azapi_resource.subnet_compute.id
  description = "Specifies the resource ID of the Compute subnet."
  sensitive   = false
}
