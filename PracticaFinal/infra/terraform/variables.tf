variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West Europe"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "techwave-app"
}

variable "app_version" {
  description = "Application version"
  type        = string
  default     = "1.0.0"
}