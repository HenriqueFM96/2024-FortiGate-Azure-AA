/*
resource "azurerm_image" "ooocustom" {
  count               = var.custom ? 1 : 0
  name                = var.custom_image_name
  resource_group_name = var.custom_image_resource_group_name
  location            = var.location
  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = var.customuri
    size_gb  = 2
  }
}


// FortiGate-VM Member A Creation
resource "azurerm_virtual_machine" "FGT-A" {
  count                        = var.custom ? 1 : 0
  name                         = "FGT_AA-Member_A"
  location                     = var.sec-hub-location
  resource_group_name          = azurerm_resource_group.azure-hub-resource-group.id
  network_interface_ids        = [azurerm_network_interface.fgt-a-port1.id, azurerm_network_interface.fgt-a-port2.id]
  primary_network_interface_id = azurerm_network_interface.fgt-a-port1.id
  vm_size                      = var.fortigate-vm-size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = var.custom ? element(azurerm_image.custom.*.id, 0) : null
  }

  storage_os_disk {
    name              = "osDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fgtvmdatadisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "FGT-A"
    admin_username = var.fgt-adminusername
    admin_password = var.fgt-adminpassword
    custom_data = templatefile("${var.bootstrap-fgt-vm-A}", {
      type         = var.license_type
      license_file = var.license-MemberA
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "FortiGate AA"
  }
}

// FortiGate-VM Member B Creation
resource "azurerm_virtual_machine" "FGT-B" {
  count                        = var.custom ? 1 : 0
  name                         = "FGT_AA-Member_B"
  location                     = var.sec-hub-location
  resource_group_name          = azurerm_resource_group.azure-hub-resource-group.id
  network_interface_ids        = [azurerm_network_interface.fgt-b-port1.id, azurerm_network_interface.fgt-b-port2.id]
  primary_network_interface_id = azurerm_network_interface.fgt-b-port1.id
  vm_size                      = var.fortigate-vm-size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = var.custom ? element(azurerm_image.custom.*.id, 0) : null
  }

  storage_os_disk {
    name              = "osDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fgtvmdatadisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "FGT-A"
    admin_username = var.fgt-adminusername
    admin_password = var.fgt-adminpassword
    custom_data = templatefile("${var.bootstrap-fgt-vm-A}", {
      type         = var.license_type
      license_file = var.license-MemberB
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "FortiGate AA - Member B"
  }
}
*/