#!/bin/bash



SUB_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)

SP_JSON=$(az ad sp create-for-rbac --name "techwave-terraform-$(date +%s)" --role Contributor --scopes /subscriptions/$SUB_ID --sdk-auth)

CLIENT_ID=$(echo $SP_JSON | jq -r '.clientId')
CLIENT_SECRET=$(echo $SP_JSON | jq -r '.clientSecret')


cat > terraform.tfvars << TFVARS
client_id = "$CLIENT_ID"
client_secret = "$CLIENT_SECRET"
subscription_id = "$SUB_ID"
tenant_id = "$TENANT_ID"
TFVARS

echo "✅ terraform.tfvars creado con valores reales"
echo ""
echo "📋 Valores obtenidos:"
echo "Subscription ID: $SUB_ID"
echo "Tenant ID: $TENANT_ID"
echo "Client ID: $CLIENT_ID"
echo "Client Secret: [PROTEGIDO]"
