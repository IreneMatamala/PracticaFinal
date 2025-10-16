#!/bin/bash
echo "Initiating rollback..."
kubectl rollout undo deployment/techwave-backend
kubectl rollout status deployment/techwave-backend
echo "Rollback completed"
