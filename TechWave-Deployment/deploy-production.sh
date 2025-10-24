empresa:
  nombre: "NombreDelCliente"
  dominio: "cliente.techwave.com"
  
azure:
  subscription_id: "12345678-1234-1234-1234-123456789012"
  # LOS SECRETS SE PROPORCIONAN POR VARIABLES DE ENTORNO

config:
  aks_cluster_name: "techwave-aks"
  resource_group: "techwave-rg"
  acr_name: "techwaveacr123"
  location: "West Europe"
  
recursos:
  node_count: 2
  vm_size: "Standard_B2s"
