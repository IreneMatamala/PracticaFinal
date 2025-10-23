#!/bin/bash
echo "=== DESPLIEGUE TECHWAVE SOLUTIONS ==="
echo ""

echo "1. APLICANDO RECURSOS KUBERNETES..."
kubectl apply -f k8s/app/namespace.yaml
kubectl apply -f k8s/app/backend-deployment.yaml
kubectl apply -f k8s/app/frontend-deployment.yaml
kubectl apply -f k8s/app/backend-service.yaml
kubectl apply -f k8s/app/frontend-service.yaml
kubectl apply -f k8s/app/web-ingress.yaml

echo ""
echo "2. ESPERANDO A QUE LOS PODS ESTÉN LISTOS..."
sleep 30

echo ""
echo "3. ESTADO DEL DESPLIEGUE:"
echo "Pods:"
kubectl get pods -n techwave-app -o wide

echo ""
echo "Services:"
kubectl get services -n techwave-app

echo ""
echo "Ingress:"
kubectl get ingress -n techwave-app

echo ""
echo "4. IP PÚBLICA: 108.141.111.214"
echo ""
echo "5. PRUEBAS DE CONECTIVIDAD:"
echo "Probando frontend..."
curl -s http://108.141.111.214/ | head -n 10 || echo "Frontend no disponible"

echo ""
echo "Probando backend..."
curl -s http://108.141.111.214/api/health || echo "Backend no disponible"

echo ""
echo "=== DESPLIEGUE COMPLETADO ==="
