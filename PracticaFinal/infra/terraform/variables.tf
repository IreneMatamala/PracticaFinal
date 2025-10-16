variable "resource_group" {
  type    = string
  default = "rg-practicafinal"
}


variable "aks_name" {
  type    = string
  default = "aks-practicafinal"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "node_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "azure_subscription_id" {
  type = string
}

variable "azure_client_id" {
  type = string
}

variable "azure_client_secret" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "aks_cluster_name" {
  type = string
}

variable "location" {
  default = "westus3"
}






