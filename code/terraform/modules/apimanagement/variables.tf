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

variable "api_management_name" {
  description = "Specifies the name of API Management."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.api_management_name) >= 2
    error_message = "Please specify a valid name."
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

variable "subnet_id" {
  description = "Specifies the resource ID of the subnet used for the deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
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

variable "encoded_certificate" {
  description = "Specifies the encoded certificate for API Management."
  type        = string
  sensitive   = true
  validation {
    condition     = var.encoded_certificate == "" || length(var.encoded_certificate) >= 2
    error_message = "Please specify a valid certificate."
  }
}
