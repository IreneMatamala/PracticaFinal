#!/bin/bash

NAMESPACE="techwave-app"
SERVICE_NAME="frontend-service"

kubectl cluster-info > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: No conectado a Kubernetes"
    exit 1
fi

CURRENT_VERSION=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.spec.selector.version}' 2>/dev/null)

if [ -z "$CURRENT_VERSION" ]; then
    CURRENT_VERSION="blue"
fi

echo "Current: $CURRENT_VERSION"

if [ "$CURRENT_VERSION" == "blue" ]; then
    NEW_VERSION="green"
else
    NEW_VERSION="blue"
fi

echo "Deploying: $NEW_VERSION"

if [ ! -f "k8s/blue-green/$NEW_VERSION-deployment.yaml" ]; then
    echo "Error: Missing k8s/blue-green/$NEW_VERSION-deployment.yaml"
    exit 1
fi

kubectl apply -f k8s/blue-green/$NEW_VERSION-deployment.yaml -n $NAMESPACE

echo "Waiting for rollout..."
kubectl rollout status deployment/frontend-$NEW_VERSION -n $NAMESPACE --timeout=180s

if [ $? -eq 0 ]; then
    kubectl patch service $SERVICE_NAME -n $NAMESPACE -p "{\"spec\":{\"selector\":{\"version\":\"$NEW_VERSION\"}}}"
    echo "Success: Traffic switched to $NEW_VERSION"
else
    echo "Error: Rollout failed, rolling back"
    kubectl rollout undo deployment/frontend-$NEW_VERSION -n $NAMESPACE
    exit 1
fi
