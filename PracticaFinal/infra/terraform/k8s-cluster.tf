provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "techwave-rg"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "techwave-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "techwave-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_container_registry" "acr" {
  name                     = "techwaveacr123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = true
  public_network_access_enabled = true
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "techwave-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "techwave"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    os_disk_type = "Managed"
    type       = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  role_based_access_control {
    enabled = true
  }

  depends_on = [azurerm_subnet.subnet]
}

resource "azurerm_role_assignment" "aks_acr" {
  principal_id   = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope          = azurerm_container_registry.acr.id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "kubeconfig" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}
