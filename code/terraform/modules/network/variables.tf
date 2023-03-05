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

variable "network_security_group_name" {
  description = "Specifies the name of the network security group."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.network_security_group_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "route_table_name" {
  description = "Specifies the name of the route table."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.route_table_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "virtual_network_name" {
  description = "Specifies the name of the virtual network."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.virtual_network_name) >= 2
    error_message = "Please specify a valid name."
  }
}
