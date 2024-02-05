#!/bin/bash

function wait_for_result() {
    job_id=$1
    access_token=$2

    for i in {1..15}; do
        response=$(curl -X GET "https://graph.microsoft.com/rp/product-ingestion/configure/$job_id/status?$version=2022-03-01-preview2" -H "Authorization: Bearer $access_token" | jq)
        echo "Response $response"
        response_status=$(jq -r '.jobResult' <<< "$response")
        if [[ ${response_status} == 'failed' ]]; then
          echo "Failed response $response"
          return 1
        fi
        if [[ ${response_status} == 'succeeded' ]]; then
          echo "Success response $response"
          return 0
        else
          echo "Attempt $i/15. Intermediate response status $response_status"
        fi
        sleep 30
    done

    echo "Retry limit exceeded"
    return 1
}
