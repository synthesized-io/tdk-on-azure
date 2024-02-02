#!/bin/bash
set -e
set -u

: "${TENANT_ID:?Need to set TENANT_ID}"
: "${AZURE_CLIENT_ID:?Need to set AZURE_CLIENT_ID}"
: "${AZURE_CLIENT_SECRET:?Need to set AZURE_CLIENT_SECRET}"

curl -X POST "https://login.microsoftonline.com/${TENANT_ID}/oauth2/v2.0/token" \
	-H "Host: login.microsoftonline.com" \
	-H "Content-Type: application/x-www-form-urlencoded" \
	-d "grant_type=client_credentials" \
	-d "client_id=${AZURE_CLIENT_ID}" \
	-d "client_secret=${AZURE_CLIENT_SECRET}" \
	-d "scope=https://graph.microsoft.com/.default" | jq .access_token
