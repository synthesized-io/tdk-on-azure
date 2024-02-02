#!/bin/bash
set -e
set -u

: "${ACCESS_TOKEN:?Need to set ACCESS_TOKEN}"
: "${PRODUCT_ID:?Need to set PRODUCT_ID}"

curl -X POST "https://graph.microsoft.com/rp/product-ingestion/configure?\$version=2022-03-01-preview2" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $ACCESS_TOKEN" \
-d '{
  "$schema": "https://schema.mp.microsoft.com/schema/configure/2022-03-01-preview2",
  "resources": [
    {
      "$schema": "https://schema.mp.microsoft.com/schema/submission/2022-03-01-preview2",
      "product": "product/'"$PRODUCT_ID"'",
      "target": { "targetType": "preview" }
    }
  ]
}'
