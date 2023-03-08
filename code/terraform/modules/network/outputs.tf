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

output "private_dns_zone_blob_id" {
  value       = azurerm_private_dns_zone.private_dns_zone_blob.id
  description = "Specifies the resource ID of the Private DNS Zone."
  sensitive   = false
}

output "private_dns_zone_key_vault_id" {
  value       = azurerm_private_dns_zone.private_dns_zone_key_vault.id
  description = "Specifies the resource ID of the Private DNS Zone."
  sensitive   = false
}

output "private_dns_zone_cognitive_service_id" {
  value       = azurerm_private_dns_zone.private_dns_zone_cognitive_service.id
  description = "Specifies the resource ID of the Private DNS Zone."
  sensitive   = false
}

output "private_dns_zone_open_ai_id" {
  value       = azurerm_private_dns_zone.private_dns_zone_open_ai.id
  description = "Specifies the resource ID of the Private DNS Zone."
  sensitive   = false
}
