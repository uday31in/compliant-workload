terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.71.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.7.0"
    }
  }

  backend "azurerm" {
    environment          = "public"
    subscription_id      = "558bd446-4212-46a2-908c-9ab0a628705e"
    resource_group_name  = "usecase-network-rg"
    storage_account_name = "usecasestg001"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  storage_use_azuread            = true
  use_oidc                       = true

  features {
    key_vault {
      recover_soft_deleted_key_vaults   = true
      recover_soft_deleted_certificates = true
      recover_soft_deleted_keys         = true
      recover_soft_deleted_secrets      = true
    }
    network {
      relaxed_locking = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

provider "azapi" {
  default_location               = var.location
  default_tags                   = var.tags
  disable_correlation_request_id = false
  environment                    = "public"
  skip_provider_registration     = false
  # use_oidc                       = true
}
