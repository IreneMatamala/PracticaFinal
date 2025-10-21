variable "resource_group_name" {
  description = "Nombre del grupo de recursos"
  default     = "techwave-rg"
}

variable "location" {
  description = "Ubicación del recurso"
  default     = "France Central"
}

variable "cluster_name" {
  description = "Nombre del clúster AKS"
  default     = "techwave-aks"
}

variable "node_count" {
  description = "Número de nodos en el clúster"
  default     = 1
}

variable "acr_name" {
  description = "Nombre del Azure Container Registry"
  default     = "techwaveacr123" # ⚠️ debe ser único globalmente, cambia el número si da error
}






