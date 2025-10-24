#!/bin/bash

# =============================================================================
# SCRIPT DE DESPLIEGUE PRODUCCIÓN - TECHWAVE SOLUTIONS
# =============================================================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
CONFIG_FILE="${1:-config.yaml}"
DEPLOYMENT_LOG="deployment-$(date +%Y%m%d-%H%M%S).log"

log() { echo -e "${GREEN}[$(date +'%H:%M:%S')] $1${NC}" | tee -a "$DEPLOYMENT_LOG"; }
error() { echo -e "${RED}[ERROR] $1${NC}" | tee -a "$DEPLOYMENT_LOG"; exit 1; }
warn() { echo -e "${YELLOW}[WARNING] $1${NC}" | tee -a "$DEPLOYMENT_LOG"; }

show_help() {
    echo "Uso: $0 [archivo-configuracion]"
    echo ""
    echo "Ejemplos:"
    echo "  $0                          
    echo "  $0 --setup                  
    echo "  $0 --help                   
}

validate_environment() {
    log "Validando entorno del cliente..."
    
   
    for cmd in az terraform kubectl docker; do
        if ! command -v $cmd &> /dev/null; then
            error "$cmd no encontrado. Instálelo antes de continuar."
        fi
    done
    
    
    if [ ! -f "$CONFIG_FILE" ]; then
        error "Archivo de configuración '$CONFIG_FILE' no encontrado.
        
Ejecute primero:
  $0 --setup
O copie y edite:
  cp config-cliente.yaml $CONFIG_FILE
  nano $CONFIG_FILE"
    fi
    
    
    if [[ -z "$AZURE_CLIENT_ID" || -z "$AZURE_CLIENT_SECRET" ]]; then
        warn "Secrets de Azure no configurados."
        echo "Ejecute:"
        echo "  export AZURE_CLIENT_ID='su-client-id'"
        echo "  export AZURE_CLIENT_SECRET='su-client-secret'"
        echo "  export AZURE_TENANT_ID='su-tenant-id'"
        error "Secrets requeridos no encontrados."
    fi
}

load_config() {
    log "Cargando configuración desde: $CONFIG_FILE"
    
    
    CLUSTER_NAME=$(grep "cluster_name:" "$CONFIG_FILE" | head -1 | cut -d: -f2 | tr -d ' "')
    RESOURCE_GROUP=$(grep "resource_group:" "$CONFIG_FILE" | head -1 | cut -d: -f2 | tr -d ' "')
    ACR_NAME=$(grep "acr_name:" "$CONFIG_FILE" | head -1 | cut -d: -f2 | tr -d ' "')
    
    export CLUSTER_NAME RESOURCE_GROUP ACR_NAME
}

setup_azure() {
    log "Autenticando en Azure..."
    az login --service-principal \
        --username "$AZURE_CLIENT_ID" \
        --password "$AZURE_CLIENT_SECRET" \
        --tenant "$AZURE_TENANT_ID" \
        --output none || error "Error en autenticación Azure"
    
    log "✓ Azure configurado"
}

deploy_infrastructure() {
    log "Desplegando infraestructura con Terraform..."
    
    cd infra/terraform
    terraform init -upgrade
    terraform validate
    terraform apply -auto-approve
    cd ../..
    
    log "✓ Infraestructura desplegada"
}

setup_kubernetes() {
    log "Configurando acceso a Kubernetes..."
    az aks get-credentials --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" --overwrite-existing
    kubectl cluster-info || error "Error conectando al cluster"
    log "✓ Kubernetes configurado"
}

deploy_application() {
    log "Desplegando aplicación..."
    
   
    az acr login --name "$ACR_NAME"
    docker build -t "$ACR_NAME.azurecr.io/backend:latest" -f src/backend/Dockerfile .
    docker build -t "$ACR_NAME.azurecr.io/frontend:latest" -f src/frontend/Dockerfile .
    docker push "$ACR_NAME.azurecr.io/backend:latest"
    docker push "$ACR_NAME.azurecr.io/frontend:latest"
    
   
    kubectl apply -f k8s/app/ -n techwave-app --wait
    kubectl rollout status deployment/frontend-deployment -n techwave-app --timeout=300s
    kubectl rollout status deployment/backend-deployment -n techwave-app --timeout=300s
    
    log "✓ Aplicación desplegada"
}

deploy_monitoring() {
    log "Desplegando monitorización..."
    
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
        --namespace monitoring --create-namespace --wait --timeout 10m
    
    kubectl apply -f k8s/monitoring/ -n monitoring
    log "✓ Monitorización desplegada"
}

generate_report() {
    log "Generando reporte final..."
    
    cat > "deployment-report-$(date +%Y%m%d).txt" << EOF
=== TECHWAVE SOLUTIONS - REPORTE DE DESPLIEGUE ===
Fecha: $(date)
Cliente: $(grep "empresa_nombre" "$CONFIG_FILE" | cut -d: -f2 | tr -d ' "')
Estado: COMPLETADO EXITOSAMENTE

Recursos desplegados:
- Cluster AKS: $CLUSTER_NAME
- Resource Group: $RESOURCE_GROUP
- Container Registry: $ACR_NAME
- Aplicación: Frontend + Backend
- Monitorización: Prometheus + Grafana + Loki

Próximos pasos:
1. Configurar DNS personalizado
2. Configurar certificados SSL
3. Realizar pruebas de aceptación
4. Entregar al equipo de desarrollo

Soporte: devops@techwave.com
EOF

    log "✓ Reporte generado"
}

main() {
    log "🚀 INICIANDO DESPLIEGUE TECHWAVE SOLUTIONS"
    
    validate_environment
    load_config
    setup_azure
    deploy_infrastructure
    setup_kubernetes
    deploy_application
    deploy_monitoring
    generate_report
    
    log "🎉 ¡DESPLIEGUE COMPLETADO!"
    log "📋 Revise el reporte generado para detalles"
}


case "${1:-}" in
    "--help"|"-h") show_help; exit 0 ;;
    "--setup") bash setup-wizard.sh; exit 0 ;;
    *) main ;;
esac
