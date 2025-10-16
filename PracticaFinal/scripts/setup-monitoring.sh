#!/usr/bin/env bash
kubectl apply -f k8s/monitoring/namespace.yaml
kubectl apply -f k8s/monitoring/prometheus.yaml
kubectl apply -f k8s/monitoring/grafana.yaml
kubectl apply -f k8s/monitoring/loki.yaml
kubectl apply -f k8s/monitoring/open-telemetry.yaml
echo "Monitoring deployed (simplificado). Recomendado usar Helm charts en producción."
