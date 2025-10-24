# PracticaFinal
# Manual de Instalación - TechWave Solutions
.
## Prerrequisitos
- Azure CLI
- kubectl
- Helm

## Pasos de instalación:
1. az login
2. ./scripts/setup-ingress.sh
3. kubectl apply -f k8s/app/
4. Verificar: kubectl get all -n techwave-app
