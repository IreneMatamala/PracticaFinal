#!/bin/bash

set -e

BLUE_VERSION="v1"
GREEN_VERSION="v2"
SERVICE_NAME="techwave-backend-service"

echo "Starting Blue-Green deployment..."

current_version=$(kubectl get deployment techwave-backend -o=jsonpath='{.metadata.labels.version}')

if [ "$current_version" == "$BLUE_VERSION" ]; then
    NEW_VERSION=$GREEN_VERSION
    OLD_VERSION=$BLUE_VERSION
else
    NEW_VERSION=$BLUE_VERSION
    OLD_VERSION=$GREEN_VERSION
fi

echo "Current version: $OLD_VERSION"
echo "Deploying new version: $NEW_VERSION"

kubectl apply -f k8s/blue-green/green-deployment.yaml

echo "Waiting for new version to be ready..."
kubectl rollout status deployment/techwave-backend-$NEW_VERSION --timeout=300s

echo "Switching traffic to new version..."
kubectl patch service $SERVICE_NAME -p "{\"spec\":{\"selector\":{\"version\":\"$NEW_VERSION\"}}}"

echo "Traffic switched successfully to version: $NEW_VERSION"

echo "Scaling down old version..."
kubectl scale deployment/techwave-backend-$OLD_VERSION --replicas=0

echo "Blue-Green deployment completed successfully"