resource "azurerm_resource_group" "ingress_rg" {
  name     = "${local.prefix}-ingress-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "logging_rg" {
  name     = "${local.prefix}-logging-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "stamp_rgs" {
  for_each = toset(var.stamps)

  name     = "${local.prefix}-${each.key}-rg"
  location = var.location
  tags     = var.tags
}
