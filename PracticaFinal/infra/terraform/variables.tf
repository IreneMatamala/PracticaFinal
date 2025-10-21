variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
  default     = "techwave-rg"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "francecentral"
}

variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
  default     = "techwaveacr123"
}

variable "aks_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "techwave-aks"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
  default     = "techwave-vnet"
}

variable "subnet_name" {
  type        = string
  description = "Name of the Subnet"
  default     = "techwave-subnet"
}



