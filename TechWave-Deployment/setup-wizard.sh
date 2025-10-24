#!/bin/bash


echo "🧙‍♂️ ASISTENTE DE CONFIGURACIÓN - TECHWAVE SOLUTIONS"
echo "=================================================="

read -p "Nombre de su empresa: " EMPRESA_NOMBRE
read -p "Email de contacto: " EMPRESA_EMAIL
read -p "Dominio deseado (ej: app.empresa.com): " EMPRESA_DOMINIO
read -p "ID de suscripción Azure: " AZURE_SUBSCRIPTION


CLUSTER_NAME="aks-${EMPRESA_NOMBRE// /-}" | tr '[:upper:]' '[:lower:]'
RESOURCE_GROUP="rg-${EMPRESA_NOMBRE// /-}" | tr '[:upper:]' '[:lower:]'
ACR_NAME="acr${EMPRESA_NOMBRE// /}" | tr '[:upper:]' '[:lower:]' | cut -c 1-15


cat > config.yaml << EOF
# Configuración generada automáticamente
empresa:
  nombre: "$EMPRESA_NOMBRE"
  contacto: "$EMPRESA_EMAIL"
  dominio: "$EMPRESA_DOMINIO"

azure:
  subscription_id: "$AZURE_SUBSCRIPTION"
  region: "West Europe"

recursos:
  cluster_name: "$CLUSTER_NAME"
  resource_group: "$RESOURCE_GROUP"
  acr_name: "$ACR_NAME"

cluster:
  node_count: 2
  vm_size: "Standard_B2s"
  auto_scaling: true

features:
  monitoring: true
  backup: true
  ssl: false

app:
  environment: "production"
  replicas: 2
  resource_limits:
    cpu: "500m"
    memory: "512Mi"
EOF

echo ""
echo "✅ Configuración guardada en: config.yaml"
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo "1. Configure los secrets de Azure:"
echo "   export AZURE_CLIENT_ID='su-client-id'"
echo "   export AZURE_CLIENT_SECRET='su-client-secret'"
echo "   export AZURE_TENANT_ID='su-tenant-id'"
echo ""
echo "2. Ejecute el despliegue:"
echo "   ./deploy-production.sh"
echo ""
echo "¿Desea ejecutar el despliegue ahora? (s/n)"
read -n 1 -r
if [[ $REPLY =~ ^[Ss]$ ]]; then
    ./deploy-production.sh
fi
