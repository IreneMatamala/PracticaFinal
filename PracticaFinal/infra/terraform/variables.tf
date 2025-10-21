variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "resource_group_name" {
  default = "techwave-rg"
}

variable "location" {
  default = "westeurope"
}

variable "aks_name" {
  default = "techwave-aks"
}

variable "acr_name" {
  default = "techwaveacr123"
}

variable "vnet_name" {
  default = "techwave-vnet"
}

variable "subnet_name" {
  default = "techwave-subnet"
}

variable "node_count" {
  default = 2
}

variable "node_vm_size" {
  default = "Standard_B2s"
}


