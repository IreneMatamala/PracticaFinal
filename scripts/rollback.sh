#!/usr/bin/env bash
set -euo pipefail
PREV_IMAGE=${1:-"[REPLACE_ME_REGISTRY]/backend:previous"}
NAMESPACE=${2:-default}

echo "Rollback: desplegando $PREV_IMAGE"
# Implementa la lógica de rollback (actualizar deployment con image anterior)
kubectl -n $NAMESPACE set image deployment/web-backend backend=${PREV_IMAGE}
