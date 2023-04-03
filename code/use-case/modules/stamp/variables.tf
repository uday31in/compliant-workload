variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
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

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "stamp" {
  description = "Specifies the stamp name."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.stamp) >= 2 && length(var.stamp) <= 10
    error_message = "Please specify a stamp name with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(any)
  sensitive   = false
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

variable "storage_container_names" {
  description = "Specifies the list of names for storage account containers."
  type        = set(string)
  sensitive   = false
  # validation {
  #   condition     = true
  #   error_message = "Please specify a valid name."
  # }
}

variable "ip_rules_cognitive_service" {
  description = "Specifies the list of IP rules for cognitive services."
  type        = set(string)
  sensitive   = false
  # validation {
  #   condition     = true
  #   error_message = "Please specify a valid name."
  # }
}

variable "ip_rules_storage" {
  description = "Specifies the list of IP rules for storage."
  type        = set(string)
  sensitive   = false
  # validation {
  #   condition     = true
  #   error_message = "Please specify a valid name."
  # }
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

variable "private_dns_zone_id_open_ai" {
  description = "Specifies the resource ID of the private DNS zone for the Cognitive Service."
  type        = string
  sensitive   = false
  validation {
    condition     = var.private_dns_zone_id_open_ai == "" || (length(split("/", var.private_dns_zone_id_open_ai)) == 9 && endswith(var.private_dns_zone_id_open_ai, "privatelink.openai.azure.com"))
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
