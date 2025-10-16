cat > scripts/blue-green-deploy.sh << 'EOF'
#!/bin/bash
set -e

SERVICE_NAME="techwave-backend-service"
CURRENT_COLOR=$(kubectl get svc $SERVICE_NAME -o jsonpath='{.spec.selector.version}')
DEPLOYMENT_NAME="techwave-backend"

echo "Current deployment color: $CURRENT_COLOR"

if [ "$CURRENT_COLOR" == "blue" ]; then
    NEW_COLOR="green"
    OLD_COLOR="blue"
else
    NEW_COLOR="blue"
    OLD_COLOR="green"
fi

echo "Deploying new $NEW_COLOR version..."

# Scale up new version
kubectl scale deployment/$DEPLOYMENT_NAME-$NEW_COLOR --replicas=3

# Wait for new version to be ready
echo "Waiting for $NEW_COLOR version to be ready..."
kubectl rollout status deployment/$DEPLOYMENT_NAME-$NEW_COLOR --timeout=300s

# Switch traffic to new version
echo "Switching traffic to $NEW_COLOR version..."
kubectl patch service $SERVICE_NAME -p "{\"spec\":{\"selector\":{\"version\":\"$NEW_COLOR\"}}}"

# Scale down old version
echo "Scaling down $OLD_COLOR version..."
kubectl scale deployment/$DEPLOYMENT_NAME-$OLD_COLOR --replicas=0

echo "Blue-Green deployment completed successfully!"
echo "Current active version: $NEW_COLOR"
EOF
