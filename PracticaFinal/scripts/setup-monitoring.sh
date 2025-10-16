#!/bin/bash
echo "Setting up monitoring stack..."
kubectl create namespace monitoring
kubectl apply -f k8s/monitoring/
echo "Monitoring stack deployed"
