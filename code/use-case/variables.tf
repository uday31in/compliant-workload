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

variable "api_management_sku" {
  description = "Specifies the sku of API Management."
  type        = string
  sensitive   = false
  validation {
    condition     = contains(["Developer", "Premium"], var.api_management_sku)
    error_message = "Please specify a valid sku."
  }
}

variable "api_management_capacity" {
  description = "Specifies the capacity of API Management."
  type        = number
  sensitive   = false
  validation {
    condition     = var.api_management_capacity > 0
    error_message = "Please specify a valid capacity."
  }
}

variable "stamps" {
  description = "Specifies the list of stamp names."
  type        = list(string)
  sensitive   = false
}

variable "api_management_email" {
  description = "Specifies the email for API Management."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.api_management_email) >= 2
    error_message = "Please specify a valid email."
  }
}

variable "publisher_name" {
  description = "Specifies the publisher for API Management."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.publisher_name) >= 2
    error_message = "Please specify a valid publisher."
  }
}
