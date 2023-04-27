locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  virtual_network = {
    resource_group_name = split("/", var.vnet_id)[4]
    name                = split("/", var.vnet_id)[8]
  }

  network_security_group = {
    resource_group_name = split("/", var.nsg_id)[4]
    name                = split("/", var.nsg_id)[8]
  }

  route_table = {
    resource_group_name = split("/", var.route_table_id)[4]
    name                = split("/", var.route_table_id)[8]
  }

  proxy_ips = [
    "89.247.164.220",
    "89.247.164.221",
    "89.247.164.222",
    "89.247.164.223",
    "89.247.164.224",
    "89.247.164.225",
    "89.247.164.226",
    "89.247.164.227",
    "89.247.164.228",
    "89.247.164.229",
    "167.220.196.158"
  ]
  apim_ips = azurerm_api_management.api_management.public_ip_addresses
  open_ai_ips_eastus = [
    "20.62.128.144/30",
    "52.146.79.224/27",
    "20.42.6.144/28",
    "20.42.7.128/27",
    "52.152.207.192/28",
    "40.79.156.64/27",
    "20.62.134.80/28",
    "52.152.207.160/28",
    "20.232.91.64/26",
    "52.179.113.128/28",
    "20.119.27.144/29",
    "20.42.6.160/27",
    "20.88.157.188/30",
    "52.186.33.48/28",
    "20.232.91.128/25",
    "52.168.112.0/26",
    "20.42.4.204/30",
    "52.179.113.96/27",
    "20.62.129.64/26",
    "20.62.129.160/27",
    "20.119.27.128/28",
    "52.146.79.144/28"
  ]
  open_ai_ips_southcentralus = [
    "20.65.130.128/26",
    "13.73.242.48/29",
    "13.73.254.200/29",
    "13.73.255.32/27",
    "20.65.130.0/26",
    "20.65.133.96/28",
    "52.255.124.80/28",
    "13.73.254.208/29",
    "13.73.249.96/27",
    "13.73.249.0/27",
    "13.73.254.216/30",
    "40.119.11.216/29",
    "13.73.249.128/28",
    "52.255.124.96/28",
    "52.255.83.208/28",
    "20.236.145.128/26",
    "52.255.124.16/28",
    "52.255.84.192/28",
    "52.255.84.176/28",
    "20.236.145.0/25",
    "13.73.242.128/26"
  ]

  stamp_open_ai_model_names = flatten([
    for stamp_key, stamp_value in module.stamps : [
      for model_name in stamp_value.open_ai_model_names : {
        stamp      = stamp_key
        endpoint   = stamp_value.open_ai_endpoint
        model_name = model_name
      }
    ]
  ])
}
