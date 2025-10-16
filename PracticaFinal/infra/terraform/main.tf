cat > infra/terraform/main.tf << 'EOF'
terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~>3.0" }
  }
}

provider "azurerm" { features {} }

resource "azurerm_resource_group" "PracticaFinal" {
  name     = "rg-practicafinal-${var.environment}"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "PracticaFinal" {
  name                = "aks-practicafinal-${var.environment}"
  location            = azurerm_resource_group.PracticaFinal.location
  resource_group_name = azurerm_resource_group.PracticaFinal.name
  dns_prefix          = "practicafinal-${var.environment}"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity { type = "SystemAssigned" }
  network_profile { network_plugin = "azure" }
}

resource "azurerm_container_registry" "PracticaFinal" {
  name                = "acrpracticafinal${var.environment}"
  resource_group_name = azurerm_resource_group.PracticaFinal.name
  location            = azurerm_resource_group.PracticaFinal.location
  sku                 = "Basic"
  admin_enabled       = true
}
EOF
