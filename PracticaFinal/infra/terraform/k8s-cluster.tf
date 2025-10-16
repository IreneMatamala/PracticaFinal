resource "azurerm_kubernetes_cluster" "PracticaFinal" {
  name                = "aks-practicafinal-${var.environment}"
  location            = azurerm_resource_group.PracticaFinal.location
  resource_group_name = azurerm_resource_group.PracticaFinal.name
  dns_prefix          = "practicafinal-${var.environment}"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  tags = {
    Environment = var.environment
    Project     = "PracticaFinal"
  }
}

resource "azurerm_container_registry" "PracticaFinal" {
  name                = "acrpracticafinal${var.environment}"
  resource_group_name = azurerm_resource_group.PracticaFinal.name
  location            = azurerm_resource_group.PracticaFinal.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    Environment = var.environment
    Project     = "PracticaFinal"
  }
}