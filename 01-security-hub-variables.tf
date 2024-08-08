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

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "payg"
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

variable "fgtversion" {
  type    = string
  default = "7.4.4"
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

variable "bootstrap-fgtvm" {
  // Change to your own path
  type    = string
  default = "fortigate.conf"
}

// license file for the fgt
variable "license" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "license.txt"
}
