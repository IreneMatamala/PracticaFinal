#!/bin/bash

echo "🔍 Instalando monitorización..."


helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace

echo "⏳ Esperando 1 minuto..."
sleep 60


kubectl get pods -n monitoring


echo "📊 URLs de Monitorización:"
kubectl get svc -n monitoring | grep -E "(prometheus|grafana)"
