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

variable "cognitive_service_name" {
  description = "Specifies the name of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cognitive_service_name) >= 2
    error_message = "Please specify a valid name."
  }
}

variable "cognitive_service_kind" {
  description = "Specifies the kind of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = contains(["AnomalyDetector", "ComputerVision", "CognitiveServices", "ContentModerator", "CustomVision.Training", "CustomVision.Prediction", "Face", "FormRecognizer", "ImmersiveReader", "LUIS", "Personalizer", "SpeechServices", "TextAnalytics", "TextTranslation", "OpenAI"], var.cognitive_service_kind)
    error_message = "Please specify a valid kind."
  }
}

variable "cognitive_service_sku" {
  description = "Specifies the name of the cognitive service."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.cognitive_service_sku) >= 1
    error_message = "Please specify a valid sku name."
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

variable "cmk_uai_id" {
  description = "Specifies the resource ID of the user assigned identity used for customer managed keys."
  type        = string
  sensitive   = false
  validation {
    condition     = var.cmk_uai_id == "" || length(split("/", var.cmk_uai_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "cmk_key_id" {
  description = "Specifies the resource ID of the user assigned identity used for customer managed keys."
  type        = string
  sensitive   = false
  validation {
    condition     = var.cmk_key_id == "" || length(var.cmk_key_id) >= 2
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
