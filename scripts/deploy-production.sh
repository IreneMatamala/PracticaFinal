#!/bin/bash


# SCRIPT DE DESPLIEGUE PRODUCCIÓN - TECHWAVE SOLUTIONS
# Versión: 2.0
# Autor: DevOps Team
# =============================================================================

set -e  # Exit on error


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# =============================================================================
# VERIFICACIÓN DE PREREQUISITOS
# =============================================================================

check_prerequisites() {
    log "Verificando prerrequisitos del sistema..."
    
    # Verificar Azure CLI
    if ! command -v az &> /dev/null; then
        error "Azure CLI no está instalado. Por favor instálelo primero."
    fi
    
    # Verificar Terraform
    if ! command -v terraform &> /dev/null; then
        error "Terraform no está instalado. Por favor instálelo primero."
    fi
    
    # Verificar kubectl
    if ! command -v kubectl &> /dev/null; then
        error "kubectl no está instalado. Por favor instálelo primero."
    fi
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        error "Docker no está instalado. Por favor instálelo primero."
    fi
    
    # Verificar archivo de configuración
    if [ ! -f "config-cliente.yaml" ]; then
        error "Archivo config-cliente.yaml no encontrado. Por favor complete la configuración."
    fi
    
    log "✓ Todos los prerrequisitos verificados correctamente"
}

# =============================================================================
# AUTENTICACIÓN Y CONFIGURACIÓN AZURE
# =============================================================================

setup_azure() {
    log "Configurando entorno Azure..."
    
   
    az login --output none
    if [ $? -ne 0 ]; then
        error "Error en login de Azure. Verifique sus credenciales."
    fi
    
    
    SUBSCRIPTION_ID=$(grep "subscription_id" config-cliente.yaml | cut -d: -f2 | tr -d ' "')
    az account set --subscription $SUBSCRIPTION_ID
    
    log "✓ Autenticación Azure completada"
}

# =============================================================================
# DESPLIEGUE DE INFRAESTRUCTURA CON TERRAFORM
# =============================================================================

deploy_infrastructure() {
    log "Iniciando despliegue de infraestructura con Terraform..."
    
    cd infra/terraform
    
    # Inicializar Terraform
    terraform init -upgrade
    
    # Validar configuración
    terraform validate
    
    # Plan de despliegue
    terraform plan -var-file="terraform.tfvars" -out=plan.out
    
    # Aplicar configuración
    terraform apply -auto-approve plan.out
    
    cd ../..
    
    log "✓ Infraestructura desplegada correctamente"
}

# =============================================================================
# CONFIGURACIÓN KUBERNETES
# =============================================================================

setup_kubernetes() {
    log "Configurando acceso a Kubernetes..."
    
    # Obtener credenciales del cluster
    az aks get-credentials \
        --resource-group techwave-rg \
        --name techwave-aks \
        --overwrite-existing
    
    # Verificar conexión al cluster
    kubectl cluster-info
    if [ $? -ne 0 ]; then
        error "Error conectando al cluster Kubernetes"
    fi
    
    log "✓ Configuración Kubernetes completada"
}

# =============================================================================
# CONSTRUCCIÓN Y DESPLIEGUE DE APLICACIÓN
# =============================================================================

deploy_application() {
    log "Construyendo y desplegando aplicación..."
    
    
    az acr login --name techwaveacr123
    
   
    docker build -t techwaveacr123.azurecr.io/backend:latest -f src/backend/Dockerfile .
    docker build -t techwaveacr123.azurecr.io/frontend:latest -f src/frontend/Dockerfile .
    
    
    docker push techwaveacr123.azurecr.io/backend:latest
    docker push techwaveacr123.azurecr.io/frontend:latest
    
    
    kubectl apply -f k8s/app/ -n techwave-app --wait=true
    
    
    kubectl rollout status deployment/frontend-deployment -n techwave-app --timeout=300s
    kubectl rollout status deployment/backend-deployment -n techwave-app --timeout=300s
    
    log "✓ Aplicación desplegada correctamente"
}

# =============================================================================
# DESPLIEGUE DE MONITORING
# =============================================================================

deploy_monitoring() {
    log "Desplegando sistema de monitorización..."
    
    
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    
   
    helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --create-namespace \
        --wait \
        --timeout 10m
    
   
    kubectl apply -f k8s/monitoring/ -n monitoring
    
    log "✓ Sistema de monitorización desplegado"
}

# =============================================================================
# CONFIGURACIÓN CI/CD
# =============================================================================

setup_cicd() {
    log "Configurando pipeline CI/CD..."
    
    
    kubectl create secret docker-registry acr-credentials \
        --docker-server=techwaveacr123.azurecr.io \
        --docker-username=$ACR_USERNAME \
        --docker-password=$ACR_PASSWORD \
        --namespace=techwave-app \
        --dry-run=client -o yaml | kubectl apply -f -
    
    log "✓ Pipeline CI/CD configurado"
}

# =============================================================================
# VERIFICACIÓN FINAL
# =============================================================================

final_verification() {
    log "Realizando verificación final del sistema..."
    
    
    kubectl get pods -n techwave-app
    kubectl get pods -n monitoring
    
    
    kubectl get services -n techwave-app
    
    
    kubectl wait --for=condition=ready pod -l app=backend -n techwave-app --timeout=120s
    kubectl wait --for=condition=ready pod -l app=frontend -n techwave-app --timeout=120s
    
    
    log "Realizando tests de funcionalidad..."
    ./scripts/health-check.sh
    
    log "✓ Verificación completada - Sistema operativo"
}

# =============================================================================
# GENERACIÓN DE REPORTE
# =============================================================================

generate_report() {
    log "Generando reporte de despliegue..."
    
    
    AKS_INFO=$(az aks show --name techwave-aks --resource-group techwave-rg --query "{name:name,location:location,powerState:powerState}" -o json)
    
    
    FRONTEND_URL=$(kubectl get ingress techwave-ingress -n techwave-app -o jsonpath='{.spec.rules[0].host}')
    GRAFANA_URL=$(kubectl get service monitoring-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    
    
    cat > deployment-report.txt << EOF
=== REPORTE DE DESPLIEGUE TECHWAVE SOLUTIONS ===
Fecha: $(date)
Estado: COMPLETADO EXITOSAMENTE

INFORMACIÓN DEL CLUSTER:
- Cluster AKS: techwave-aks
- Resource Group: techwave-rg
- Región: West Europe
- Estado: Operativo

ENDPOINTS DE ACCESO:
- Aplicación: http://$FRONTEND_URL
- Monitorización: http://$GRAFANA_URL:3000
- Credenciales Grafana: admin / prometheus

RECURSOS DESPLEGADOS:
✓ Cluster Kubernetes (AKS)
✓ Registry de contenedores (ACR)
✓ Aplicación Frontend/Backend
✓ Sistema de monitorización completo
✓ Pipeline CI/CD configurado

PRÓXIMOS PASOS:
1. Configurar DNS para los dominios corporativos
2. Configurar certificados SSL/TLS
3. Realizar pruebas de carga
4. Entregar al equipo de desarrollo

Para soporte técnico contactar: devops@techwave.com
EOF

    log "✓ Reporte generado: deployment-report.txt"
}

# =============================================================================
# FUNCIÓN PRINCIPAL
# =============================================================================

main() {
    log "🚀 INICIANDO DESPLIEGUE AUTOMATIZADO TECHWAVE SOLUTIONS"
    log "Este proceso tomará aproximadamente 30-45 minutos..."
    
    
    check_prerequisites
    setup_azure
    deploy_infrastructure
    setup_kubernetes
    deploy_application
    deploy_monitoring
    setup_cicd
    final_verification
    generate_report
    
    log "🎉 ¡DESPLIEGUE COMPLETADO EXITOSAMENTE!"
    log "📋 Revise el archivo deployment-report.txt para detalles y próximos pasos"
    log "🌐 La aplicación está disponible y operativa"
}


main "$@"
