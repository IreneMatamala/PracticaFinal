#!/bin/bash

echo "🚀 Testing CI/CD locally..."


echo "📥 Checking out code..."
cd /home/azureuser/PracticaFinal/PracticaFinal

echo "🏗️ Applying Kubernetes manifests..."
kubectl apply -f k8s/app/ -n techwave-app

echo "⏳ Waiting for rollout..."
kubectl rollout status deployment/frontend-deployment -n techwave-app --timeout=180s
kubectl rollout status deployment/backend-deployment -n techwave-app --timeout=180s

echo "🧪 Testing application..."
kubectl port-forward -n techwave-app service/frontend-service 8080:80 &
sleep 5
curl -s http://localhost:8080/ | head -2

kubectl port-forward -n techwave-app service/backend-service 5000:5000 &
sleep 3
curl -s http://localhost:5000/health


pkill -f "kubectl port-forward"

echo "✅ Local CI/CD test completed!"
