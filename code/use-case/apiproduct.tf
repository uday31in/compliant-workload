resource "azurerm_api_management_product" "api_management_product" {
  product_id            = "open-ai-model-product"
  api_management_name   = azurerm_api_management.api_management.name
  resource_group_name   = azurerm_api_management.api_management.resource_group_name
  display_name          = "Open AI Model Product"
  subscription_required = false
  approval_required     = false
  published             = true
}

resource "azurerm_api_management_product_api" "api_management_product_apis" {
  for_each            = azurerm_api_management_api.api_open_ai_inference
  api_name            = azurerm_api_management_api.api_open_ai_inference[each.key].name
  product_id          = azurerm_api_management_product.api_management_product.product_id
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = azurerm_api_management.api_management.resource_group_name
}
