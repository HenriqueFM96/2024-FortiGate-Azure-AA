
# REMOVE THIS COMMENT TO RUN PROPERLY 


#########################################################################################
#                               Security HUB Infra Creation                             #
#########################################################################################

resource "azurerm_resource_group" "azure-hub-resource-group" {
  name     = "${var.ContentTAG}${var.TAG_HUB}_Resource_Group"
  location = var.sec-hub-location
}

resource "azurerm_network_security_group" "azure-hub-sg" {
  name                = "vnet-${var.TAG_HUB}-security-group"
  location            = azurerm_resource_group.azure-hub-resource-group.location
  resource_group_name = azurerm_resource_group.azure-hub-resource-group.name

  security_rule {
    name                       = "allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    architecture = "${var.TAG_HUB}"
    environment = "${var.StageTAG_PROD}"
  }

}

resource "azurerm_virtual_network" "azure-hub-vnet" {
  name                = "${var.TAG_HUB}_vNET"
  location            = azurerm_resource_group.azure-hub-resource-group.location
  resource_group_name = azurerm_resource_group.azure-hub-resource-group.name
  address_space       = ["${var.hub-vnetcidr}"]

  tags = {
    architecture = "${var.TAG_HUB}"
    environment = "${var.StageTAG_PROD}"
  }
}

resource "azurerm_subnet" "azure-hub-untrusted" {
  name                 = "FGT-Public_Subnet"
  resource_group_name  = azurerm_resource_group.azure-hub-resource-group.name
  virtual_network_name = azurerm_virtual_network.azure-hub-vnet.name
  address_prefixes     = ["${var.hub-publiccidr}"]
}

resource "azurerm_subnet" "azure-hub-trusted" {
  name                 = "FGT_Private_Subnet"
  resource_group_name  = azurerm_resource_group.azure-hub-resource-group.name
  virtual_network_name = azurerm_virtual_network.azure-hub-vnet.name
  address_prefixes     = ["${var.hub-privatecidr}"]
}

#########################################################################################
#                                  Azure Load Balancers                                 #
#########################################################################################

# External Load Balancer
resource "azurerm_public_ip" "fgt-lb-pip" {
  name                = "FortiGate-LB-PIP"
  location            = azurerm_resource_group.azure-hub-resource-group.location
  resource_group_name = azurerm_resource_group.azure-hub-resource-group.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "fgt-external-lb" {
  name                = "External-LB"
  location            = azurerm_resource_group.azure-hub-resource-group.location
  resource_group_name = azurerm_resource_group.azure-hub-resource-group.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.fgt-lb-pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "external-lb-backend-pool" {
  loadbalancer_id = azurerm_lb.fgt-external-lb.id
  name            = "External-LB-BackEndAddressPool"
}

# Internal Load Balancer
# Create an Internal Load Balancer
resource "azurerm_lb" "internal-lb" {
  name = "Internal-LB"
  location = azurerm_resource_group.azure-hub-resource-group.location
  resource_group_name = azurerm_resource_group.azure-hub-resource-group.name
  sku = "Standard"

  frontend_ip_configuration {
    name = "internal-frontend-ip"
    subnet_id = azurerm_subnet.azure-hub-trusted.id
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "internal-lb-pool" {
  loadbalancer_id = azurerm_lb.internal-lb.id
  name = "internal-lb-pool"
}

resource "azurerm_lb_probe" "internal-lb-probe" {
  loadbalancer_id = azurerm_lb.internal-lb.id
  name = "test-probe"
  port = 80
}

resource "azurerm_lb_rule" "internal-lb-rule" {
  loadbalancer_id = azurerm_lb.internal-lb.id
  name = "test-rule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  disable_outbound_snat = true
  frontend_ip_configuration_name = "internal-frontend-ip"
  probe_id = azurerm_lb_probe.internal-lb-probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.internal-lb-pool.id]
}

#########################################################################################
#                                FortiGate-VM Interfaces                                #
#########################################################################################

// Allocated Public IP
resource "azurerm_public_ip" "FGTPublicIp" {
  name                = "FGTPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-hub-resource-group.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "Terraform Single FortiGate PIP"
  }
}

// FGT Network Interface port1
resource "azurerm_network_interface" "fgtport1" {
  name                = "fgtport1"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure-hub-resource-group.name
  
  timeouts {
    delete = "5m"
  }

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.azure-hub-untrusted.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.FGTPublicIp.id
  }

  tags = {
    environment = "Terraform Single FortiGate"
  }
}

resource "azurerm_network_interface_security_group_association" "fgt-port1-nsg" {
  network_interface_id      = azurerm_network_interface.fgtport1.id
  network_security_group_id = azurerm_network_security_group.azure-hub-sg.id
}

resource "azurerm_network_interface" "fgtport2" {
  name                 = "fgtport2"
  location             = var.location
  resource_group_name  = azurerm_resource_group.azure-hub-resource-group.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.azure-hub-trusted.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "Terraform Single FortiGate"
  }
}

resource "azurerm_network_interface_security_group_association" "fgt-port2-nsg" {
  network_interface_id      = azurerm_network_interface.fgtport2.id
  network_security_group_id = azurerm_network_security_group.azure-hub-sg.id
}
