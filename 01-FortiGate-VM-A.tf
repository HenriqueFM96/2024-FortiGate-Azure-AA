resource "azurerm_image" "custom" {
  count               = var.custom ? 1 : 0
  name                = var.custom_image_name
  resource_group_name = var.custom_image_resource_group_name
  location            = var.sec-hub-location
  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = var.customuri
    size_gb  = 2
  }
}

resource "azurerm_virtual_machine" "customactivefgtvm" {
  count                        = var.custom ? 1 : 0
  name                         = "customactivefgt"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.azure-hub-resource-group.name
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
    name              = "activedatadisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "customactivefgt"
    admin_username = var.fgt-adminusername
    admin_password = var.fgt-adminpassword
    custom_data = templatefile("${var.bootstrap-fgt-vm-A}", {
      type            = var.license_type
      license_file    = var.license-MemberA
      format          = "${var.license_format}"
      port1_ip        = var.hub-fgt_A-external-ip-address
      port1_mask      = "255.255.255.0"
      port2_ip        = var.hub-fgt_A-internal-ip-address
      port2_mask      = "255.255.255.0"
      passive_peerip  = var.hub-fgt_B-external-ip-address
      mgmt_gateway_ip = "10.0.0.1"
      defaultgwy      = "10.0.0.1"
      tenant          = var.tenant_id
      subscription    = var.subscription_id
      clientid        = var.client_id
      clientsecret    = var.client_secret
      adminsport      = "443"
      rsg             = azurerm_resource_group.azure-hub-resource-group.name
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "FortiGate AA"
  }
}


resource "azurerm_virtual_machine" "activefgtvm" {
  count                        = var.custom ? 0 : 1
  name                         = "activefgt"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.azure-hub-resource-group.name
  network_interface_ids        = [azurerm_network_interface.fgt-a-port1.id, azurerm_network_interface.fgt-a-port2.id]
  primary_network_interface_id = azurerm_network_interface.fgt-a-port1.id
  vm_size                      = var.fortigate-vm-size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.custom ? null : var.publisher
    offer     = var.custom ? null : var.fgtoffer
    sku       = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    version   = var.custom ? null : var.fgtversion
    id        = var.custom ? element(azurerm_image.custom.*.id, 0) : null
  }

  plan {
    name      = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    publisher = var.publisher
    product   = var.fgtoffer
  }


  storage_os_disk {
    name              = "osDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "activedatadisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "activefgt"
    admin_username = var.fgt-adminusername
    admin_password = var.fgt-adminpassword
    custom_data = templatefile("${var.bootstrap-fgt-vm-A}", {
      type            = var.license_type
      license_file    = var.license-MemberA
      format          = "${var.license_format}"
      port1_ip        = var.hub-fgt_A-external-ip-address
      port1_mask      = "255.255.255.0"
      port2_ip        = var.hub-fgt_A-internal-ip-address
      port2_mask      = "255.255.255.0"
      passive_peerip  = var.hub-fgt_B-external-ip-address
      mgmt_gateway_ip = "10.0.0.1"
      defaultgwy      = "10.0.0.1"
      tenant          = var.tenant_id
      subscription    = var.subscription_id
      clientid        = var.client_id
      clientsecret    = var.client_secret
      adminsport      = "443"
      rsg             = azurerm_resource_group.azure-hub-resource-group.name
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "FortiGate AA"
  }
}