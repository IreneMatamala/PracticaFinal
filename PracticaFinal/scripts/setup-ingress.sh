#!/bin/bash
echo "=== INSTALACIÓN NGINX INGRESS CONTROLLER ==="


if ! command -v helm &> /dev/null; then
    echo "Instalando Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi


echo "Agregando repositorio de ingress-nginx..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update


echo "Instalando NGINX Ingress Controller..."
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz

echo "Esperando a que el Ingress Controller esté listo..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=600s

echo "=== INGRESS CONTROLLER INSTALADO ==="
echo "Obteniendo información del servicio..."
kubectl get service ingress-nginx-controller --namespace ingress-nginx

echo ""
echo "Para obtener la IP externa, ejecuta:"
echo "kubectl get service ingress-nginx-controller -n ingress-nginx -w"
