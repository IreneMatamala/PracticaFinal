variable "subscription_id" { type = string }
variable "resource_group" { type = string, default = "rg-practicafinal" }
variable "location" { type = string, default = "westeurope" }
variable "aks_name" { type = string, default = "aks-practicafinal" }
variable "node_count" { type = number, default = 2 }
variable "node_size" { type = string, default = "Standard_DS2_v2" }
