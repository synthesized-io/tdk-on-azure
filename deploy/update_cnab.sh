#!/bin/bash
set -e
set -u

: "${ACCESS_TOKEN:?Need to set ACCESS_TOKEN}"
: "${TENANT_ID:?Need to set TENANT_ID}"
: "${SUBSCRIPTION_ID:?Need to set SUBSCRIPTION_ID}"
: "${RESOURCE_GROUP:?Need to set RESOURCE_GROUP}"
: "${PRODUCT_ID:?Need to set PRODUCT_ID}"
: "${PLAN_ID:?Need to set PLAN_ID}"
: "${PLAN_NAME:?Need to set PLAN_NAME}"
: "${REGISTRY_NAME:?Need to set REGISTRY_NAME}"
: "${REPOSITORY_NAME:?Need to set REPOSITORY_NAME}"
: "${CNAB_TAG:?Need to set CNAB_TAG}"
: "${CNAB_DIGEST:?Need to set CNAB_DIGEST}"

curl -X POST 'https://graph.microsoft.com/rp/product-ingestion/configure?$version=2022-03-01-preview2' \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-d '{
  "$schema": "https://schema.mp.microsoft.com/schema/configure/2022-03-01-preview2",
  "resources": [
    {
      "$schema": "https://product-ingestion.azureedge.net/schema/container-plan-technical-configuration/2022-03-01-preview3",
      "id": "container-plan-technical-configuration/'"$PRODUCT_ID"'/'"$PLAN_ID"'",
      "product": "product/'"$PRODUCT_ID"'",
      "plan": "plan/'"$PRODUCT_ID"'/'"$PLAN_ID"'",
      "payloadType": "cnab",
      "clusterExtensionType": "'"$PLAN_NAME"'",
      "cnabReferences": [
        {
          "tenantId": "'"$TENANT_ID"'",
          "subscriptionId": "'"$SUBSCRIPTION_ID"'",
          "resourceGroupName": "'"$RESOURCE_GROUP"'",
          "registryName": "'"$REGISTRY_NAME"'",
          "repositoryName": "'"$REPOSITORY_NAME"'",
          "tag": "'"$CNAB_TAG"'",
          "digest": '"$CNAB_DIGEST"'
        }
      ]
    }
  ]
}'
