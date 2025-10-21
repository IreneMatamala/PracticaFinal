resource "azurerm_resource_group" "rg" {
  name     = "techwave-rg-nuevo"
  location = "francecentral"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "techwave-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "techwave-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "techwave-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "techwave"
  kubernetes_version  = "1.27.3"

  default_node_pool {
    name         = "default"
    node_count   = 1
    vm_size      = "Standard_B2s"
    os_disk_type = "Managed"
    type         = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_resource_group" {
  value = azurerm_resource_group.rg.name
}

output "aks_cluster_kubeconfig" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}

