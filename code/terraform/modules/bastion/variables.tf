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

variable "bastion_name" {
  description = "Specifies the name of the bastion service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.bastion_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "vm_name" {
  description = "Specifies the name of the virtual machine."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.vm_name) >= 2
    error_message = "Please specify a valid name."
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

variable "subnet_bastion_id" {
  description = "Specifies the resource ID of the subnet used for the bastion host."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_bastion_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

variable "subnet_compute_id" {
  description = "Specifies the resource ID of the subnet used for the compute."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.subnet_compute_id)) == 11
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
