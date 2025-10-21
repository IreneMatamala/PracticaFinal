

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "kubeconfig" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
