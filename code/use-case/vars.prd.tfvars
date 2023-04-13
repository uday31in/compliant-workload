location                = "eastus"
environment             = "prd"
prefix                  = "mb30"
tags                    = {}
vnet_id                 = "/subscriptions/558bd446-4212-46a2-908c-9ab0a628705e/resourceGroups/usecase-network-rg/providers/Microsoft.Network/virtualNetworks/usecase-vnet"
nsg_id                  = "/subscriptions/558bd446-4212-46a2-908c-9ab0a628705e/resourceGroups/usecase-network-rg/providers/Microsoft.Network/networkSecurityGroups/usecase-nsg"
route_table_id          = "/subscriptions/558bd446-4212-46a2-908c-9ab0a628705e/resourceGroups/usecase-network-rg/providers/Microsoft.Network/routeTables/usecase-rt"
api_management_sku      = "Developer"
api_management_capacity = 1
stamps = [
  "stp01",
  "stp02"
]
api_management_email = "mabuss@microsoft.com"
publisher_name       = "Contoso"
