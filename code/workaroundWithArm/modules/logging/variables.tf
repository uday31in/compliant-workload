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

variable "log_analytics_workspace_name" {
  description = "Specifies the name of the log analytics workspace."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.log_analytics_workspace_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "application_insights_name" {
  description = "Specifies the name of application insights."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.application_insights_name) >= 2
    error_message = "Please specify a valid name."
  }
}
