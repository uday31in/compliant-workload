variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["dev", "tst", "prd"], var.environment)
    error_message = "Please use an allowed value: \"dev\", \"tst\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
  sensitive   = false
}

variable "vnet_id" {
  description = "Specifies the resource ID of the Vnet used for the Data Landing Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.vnet_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "nsg_id" {
  description = "Specifies the resource ID of the default network security group for the Data Landing Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.nsg_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "route_table_id" {
  description = "Specifies the resource ID of the default route table for the Data Landing Zone"
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.route_table_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "admin_password" {
  description = "Specifies the admin password of the virtual machine."
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 2
    error_message = "Please specify a valid password."
  }
}

variable "admin_username" {
  description = "Specifies the admin username of the virtual machine."
  type        = string
  default     = "VmMainUser"
  sensitive   = false
  validation {
    condition     = length(var.admin_username) >= 2
    error_message = "Please specify a valid password."
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

variable "private_dns_zone_id_cognitive_service" {
  description = "Specifies the resource ID of the private DNS zone for the Cognitive Service."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_cognitive_service == "" || (length(split("/", var.private_dns_zone_id_cognitive_service)) == 9 && (endswith(var.private_dns_zone_id_cognitive_service, "privatelink.cognitiveservices.azure.com") || endswith(var.private_dns_zone_id_cognitive_service, "privatelink.openai.azure.com")))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
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

variable "private_dns_zone_id_dfs" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage dfs endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_dfs == "" || (length(split("/", var.private_dns_zone_id_dfs)) == 9 && endswith(var.private_dns_zone_id_dfs, "privatelink.dfs.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_queue" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage queue endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_queue == "" || (length(split("/", var.private_dns_zone_id_queue)) == 9 && endswith(var.private_dns_zone_id_queue, "privatelink.queue.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_key_vault" {
  description = "Specifies the resource ID of the private DNS zone for Azure Key Vault."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_key_vault == "" || (length(split("/", var.private_dns_zone_id_key_vault)) == 9 && endswith(var.private_dns_zone_id_key_vault, "privatelink.vaultcore.azure.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}
