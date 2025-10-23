#!/bin/bash

echo "=== INFORMACIÓN DE AZURE AKS ==="
echo ""

echo "1. VERIFICANDO LOGIN EN AZURE:"
az account show --output table || { echo "No estás logueado en Azure. Ejecuta: az login"; exit 1; }

echo ""

echo "2. RESOURCE GROUPS:"
az group list --query "[].{Name:name, Location:location}" --output table

echo ""

echo "3. AKS CLUSTERS:"
az aks list --query "[].{Name:name, ResourceGroup:resourceGroup, Location:location, KubernetesVersion:kubernetesVersion}" --output table

echo ""


echo "4. KUBERNETES CONTEXT:"
kubectl config current-context

echo ""


echo "5. INFORMACIÓN DEL CLUSTER:"
kubectl cluster-info 2>/dev/null || echo "No conectado a un cluster"

echo ""


echo "6. HELM:"
helm version --short 2>/dev/null || echo "Helm no está instalado"

echo ""
echo "=== FIN DE LA INFORMACIÓN ==="

