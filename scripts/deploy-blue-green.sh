#!/usr/bin/env bash
set -euo pipefail
COLOR=${1:-green}
IMAGE=${2:-"[REPLACE_ME_REGISTRY]/backend:latest"}
NAMESPACE=${3:-default}

echo "Desplegando color $COLOR con imagen $IMAGE en namespace $NAMESPACE"

kubectl -n $NAMESPACE apply -f k8s/blue-green/${COLOR}-deployment.yaml
# Actualizar service para apuntar a la versión correcta
kubectl -n $NAMESPACE patch svc web-backend-svc --type='json' -p="[ { \"op\": \"replace\", \"path\": \"/spec/selector/version\", \"value\": \"${COLOR}\" } ]"
echo "Tráfico cambiado a ${COLOR}"
