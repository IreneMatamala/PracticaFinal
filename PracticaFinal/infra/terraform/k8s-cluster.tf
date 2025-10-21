
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "techwave-aks"
  location            = "francecentral"
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "techwave"

  kubernetes_version = "1.27.3"  # versión estable

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

role_based_access_control_enabled = true

network_profile {
  network_plugin    = "azure"
  load_balancer_sku = "standard"
  }
}

