#!/bin/bash

# Use command substitution to store the response and code
response=$(curl -s -w "HTTPSTATUS:%{http_code}" "https://example.com")
response_body=$(echo $response | sed 's/HTTPSTATUS:.*//')
response_code=$(echo $response | sed -n 's/.*\(HTTPSTATUS:.*\)/\1/p' | sed 's/^HTTPSTATUS://')

echo "Response Code:$response_code"
echo "Response Body:$response_body"
