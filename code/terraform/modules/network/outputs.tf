output "subnet_private_endpoints_id" {
  value       = azapi_resource.subnet_private_endpoints.id
  description = "Specifies the resource ID of the Private Endpoint subnet."
  sensitive   = false
}
