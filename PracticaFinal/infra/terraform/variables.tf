variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "techwave-aks"
}

variable "location" {
  description = "Azure location for the cluster"
  type        = string
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
  default     = "techwave-rg"
}

variable "node_count" {
  description = "Number of nodes in default node pool"
  type        = number
  default     = 1
}

variable "node_size" {
  description = "Size of the AKS VM nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "environment_name" {
  description = "Environment name tag"
  type        = string
  default     = "dev"
}

