#!/bin/bash

# Default serial number
DEFAULT_SERIAL="arn:aws:iam::736763050260:mfa/scott.walter"

# Prompt for serial number with default
echo -n "Enter Serial Number (press Enter for default): "
read SERIAL_NUMBER

# Use default if empty
if [ -z "$SERIAL_NUMBER" ]; then
    SERIAL_NUMBER="$DEFAULT_SERIAL"
fi

echo "Using Serial Number: $SERIAL_NUMBER"

# Prompt for MFA code
echo -n "Enter MFA Code: "
read MFA_CODE

# Validate MFA code is provided
if [ -z "$MFA_CODE" ]; then
    echo "Error: MFA Code is required"
    exit 1
fi

echo "Getting session token..."

# Run AWS STS command and capture output
AWS_OUTPUT=$(aws sts get-session-token --serial-number "$SERIAL_NUMBER" --token-code "$MFA_CODE" 2>&1)

# Check if command was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to get session token"
    echo "$AWS_OUTPUT"
    exit 1
fi

# Display the full response
echo "Response:"
echo "$AWS_OUTPUT"

# Parse the JSON response and extract credentials
ACCESS_KEY_ID=$(echo "$AWS_OUTPUT" | grep -o '"AccessKeyId": *"[^"]*"' | cut -d'"' -f4)
SECRET_ACCESS_KEY=$(echo "$AWS_OUTPUT" | grep -o '"SecretAccessKey": *"[^"]*"' | cut -d'"' -f4)
SESSION_TOKEN=$(echo "$AWS_OUTPUT" | grep -o '"SessionToken": *"[^"]*"' | cut -d'"' -f4)

# Check if we successfully parsed the credentials
if [ -z "$ACCESS_KEY_ID" ] || [ -z "$SECRET_ACCESS_KEY" ] || [ -z "$SESSION_TOKEN" ]; then
    echo "Error: Failed to parse credentials from response"
    exit 1
fi

# Export environment variables
export AWS_ACCESS_KEY_ID="$ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$SECRET_ACCESS_KEY"
export AWS_SESSION_TOKEN="$SESSION_TOKEN"

echo ""
echo "Environment variables set:"
echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
echo "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
echo "export AWS_SESSION_TOKEN=$SESSION_TOKEN"

echo ""
echo "Session token expires at: $(echo "$AWS_OUTPUT" | grep -o '"Expiration": *"[^"]*"' | cut -d'"' -f4)"
echo ""
echo "To use these credentials in your current shell, run:"
echo "source $0"

aws sts get-caller-identity
