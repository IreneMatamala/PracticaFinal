#!/bin/bash
set -e
echo "Starting Blue-Green Deployment..."
SERVICE_NAME="techwave-backend-service"
kubectl apply -f k8s/blue-green/
echo "Blue-Green deployment initiated"
