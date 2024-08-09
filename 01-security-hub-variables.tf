#########################################
#         Security HUB Location         #
#########################################

variable "sec-hub-location" {
    type = string
    default = "Central US"
}

#########################################
#            VAR Spokes TAGs            #
#########################################

// var Content TAG
variable "sec-hub-ContentTAG" {
    type = string
    default = "Demo-"
}

// var PROD TAG
variable "sec-hub-StageTAG_PROD" {
    type = string
    default = "SEC"
}

// var Security HUB TAG
variable "TAG_HUB" {
    type = string
    default = "Security-HUB"
}

##########################################
#          FortiGate-VM Variables        #
##########################################

// To use custom image
// by default is false
variable "custom" {
  default = false
}

//  Custom image blob uri
variable "customuri" {
  type    = string
  default = "<custom image blob uri>"
}

variable "custom_image_name" {
  type    = string
  default = "<custom image name>"
}

variable "custom_image_resource_group_name" {
  type    = string
  default = "<custom image resource group>"
}

variable "publisher" {
  type    = string
  default = "fortinet"
}

variable "fgtoffer" {
  type    = string
  default = "fortinet_fortigate-vm_v5"
}

// BYOL sku: fortinet_fg-vm
// PAYG sku: fortinet_fg-vm_payg_2022
variable "fgtsku" {
  type = map(any)
  default = {
    byol = "fortinet_fg-vm"
    payg = "fortinet_fg-vm_payg_2023"
  }
}

variable "fgt-adminusername" {
  type    = string
  default = "azureadmin"
}

variable "fgt-adminpassword" {
  type    = string
  default = "Fortinet123#"
}

variable "hub-vnetcidr" {
  default = "10.0.0.0/16"
}

variable "hub-publiccidr" {
  default = "10.0.0.0/24"
}

variable "hub-privatecidr" {
  default = "10.0.10.0/24"
}

# Internal Load Balancer IP
variable "hub-ilb-ip-address" {
  default = "10.0.10.4"
}

# FortiGate Member A - External IP
variable "hub-fgt_A-external-ip-address" {
  default = "10.0.0.10"
}

# FortiGate Member A - Internal IP
variable "hub-fgt_A-internal-ip-address" {
  default = "10.0.10.10"
}

# FortiGate Member B - External IP
variable "hub-fgt_B-external-ip-address" {
  default = "10.0.0.11"
}

# FortiGate Member B - Internal IP
variable "hub-fgt_B-internal-ip-address" {
  default = "10.0.10.11"
}

variable "bootstrap-fgt-vm-A" {
  type    = string
  default = "01-fortigate-vm-A.conf"
}

variable "bootstrap-fgt-vm-B" {
  type    = string
  default = "01-fortigate-vm-B.conf"
}

variable "license_type" {
  default = "byol"
}

// license file for the fgt
variable "license-MemberA" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "FGT-VM-MemberA.txt"
}

variable "license-MemberB" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "FGT-VM-MemberB.txt"
}

variable "fgtversion" {
  type    = string
  default = "7.6.0"
}

variable "fortigate-vm-size" {
  type = string
  default = "Standard_B1s"
}
