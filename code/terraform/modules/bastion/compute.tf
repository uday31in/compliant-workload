resource "azurerm_network_interface" "network_interface" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  enable_accelerated_networking = false
  enable_ip_forwarding          = false
  # internal_dns_name_label = ""
  ip_configuration {
    name                          = "ipConfiguration"
    primary                       = true
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    subnet_id                     = var.subnet_compute_id
  }
}

resource "azurerm_disk_encryption_set" "disk_encryption_set" {
  name                = "${var.vm_name}-des"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  auto_key_rotation_enabled = false
  encryption_type           = "EncryptionAtRestWithCustomerKey"
  key_vault_key_id          = data.azurerm_key_vault_key.key_vault_key.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  admin_password             = var.admin_password
  admin_username             = var.admin_username
  allow_extension_operations = true
  computer_name              = substr(var.vm_name, 0, 15)
  enable_automatic_updates   = true
  encryption_at_host_enabled = true
  hotpatching_enabled        = false
  network_interface_ids = [
    azurerm_network_interface.network_interface.id
  ]
  license_type = "None"
  os_disk {
    name                      = "${var.vm_name}-disk"
    caching                   = "ReadWrite"
    disk_encryption_set_id    = azurerm_disk_encryption_set.disk_encryption_set.id
    storage_account_type      = "StandardSSD_LRS"
    write_accelerator_enabled = false
  }
  patch_assessment_mode = "ImageDefault"
  patch_mode            = "AutomaticByOS"
  priority              = "Regular"
  provision_vm_agent    = true
  secure_boot_enabled   = true
  source_image_reference {
    offer     = "windows-11"
    publisher = "microsoftwindowsdesktop"
    sku       = "win11-22h2-pro"
    version   = "latest"
  }
  size         = "Standard_D2s_v5"
  timezone     = "UTC"
  vtpm_enabled = true

  depends_on = [
    azurerm_role_assignment.role_assignment_key_vault
  ]
}
