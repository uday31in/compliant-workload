resource "azurerm_api_management_api_version_set" "api_management_api_version_set" {
  name                = "ApiVersionSet"
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = azurerm_api_management.api_management.resource_group_name

  display_name      = "DefaultApiVersionSet"
  description       = "Default API Version Set using the Path."
  versioning_scheme = "Segment"
}

resource "azurerm_api_management_api" "api_open_ai_inference" {
  for_each            = { for item in local.stamp_open_ai_model_names : "${item.stamp}-${item.model_name}" => item }
  name                = each.key
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = azurerm_api_management.api_management.resource_group_name

  api_type = "http"
  # contact {
  #   email = ""
  #   name  = ""
  #   url   = ""
  # }
  display_name = "Inference API - ${each.value.stamp} - ${each.value.model_name}"
  description  = "Inference API for the Open AI model ${each.value.model_name} in stamp ${each.value.stamp}."
  import {
    content_format = "openapi+json"
    content_value = templatefile(
      "${path.module}/swagger/openai_inference_2022-12-01.json",
      {
        deployment-id = each.value.model_name,
        stamp         = each.value.stamp
        endpoint      = each.value.endpoint
      }
    )
  }
  path                  = each.key
  protocols             = ["https"]
  revision              = "1"
  revision_description  = "This is the initial revision."
  service_url           = "${each.value.endpoint}openai/"
  subscription_required = false
  version               = "v1"
  version_description   = "Version v1 of the Open AI API."
  version_set_id        = azurerm_api_management_api_version_set.api_management_api_version_set.id
}

resource "azurerm_api_management_api_diagnostic" "api_open_ai_inference_diagnostic" {
  for_each                 = azurerm_api_management_api.api_open_ai_inference
  identifier               = "applicationinsights"
  resource_group_name      = azurerm_api_management.api_management.resource_group_name
  api_management_name      = azurerm_api_management.api_management.name
  api_name                 = azurerm_api_management_api.api_open_ai_inference[each.key].name
  api_management_logger_id = azurerm_api_management_logger.api_management_logger.id

  sampling_percentage       = 5.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "information"
  http_correlation_protocol = "W3C"
  operation_name_format     = "Name"

  frontend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  frontend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }

  backend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  backend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }
}


