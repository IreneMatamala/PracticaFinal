variable "resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group"
  default     = "techwave-rg"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
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


variable "subscription_id" {
  type        = string
  description = "ID de la suscripción de Azure"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID de Azure"
  sensitive   = true
}

variable "client_id" {
  type        = string
  description = "Client ID del Service Principal"
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Client Secret del Service Principal"
  sensitive   = true
}



