output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}



output "kube_config_raw" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}


output "cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.aks.name
}


output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}


output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${var.aks_cluster_name} --overwrite-existing"
}


output "cluster_fqdn" {
  description = "Cluster FQDN"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}






