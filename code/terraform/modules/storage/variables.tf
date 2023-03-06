variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
  sensitive   = false
}

variable "resource_group_name" {
  description = "Specifies the name of the resource group."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.resource_group_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "storage_name" {
  description = "Specifies the name of the storage accounts."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.storage_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "storage_container_names" {
  description = "Specifies the list of names for storage account containers."
  type        = set(string)
  sensitive   = false
  # validation {
  #   condition     = true
  #   error_message = "Please specify a valid name."
  # }
}

variable "subnet_id" {
  description = "Specifies the resource ID of the subnet used for the deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

variable "cmk_uai_id" {
  description = "Specifies the resource ID of the user assigned identity used for customer managed keys."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.cmk_uai_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "cmk_key_vault_id" {
  description = "Specifies the resource ID of the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.cmk_key_vault_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "cmk_key_name" {
  description = "Specifies the resource ID of the key vault."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cmk_key_name) >= 2
    error_message = "Please specify a valid resource ID."
  }
}

variable "private_dns_zone_id_blob" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_blob == "" || (length(split("/", var.private_dns_zone_id_blob)) == 9 && endswith(var.private_dns_zone_id_blob, "privatelink.blob.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}
