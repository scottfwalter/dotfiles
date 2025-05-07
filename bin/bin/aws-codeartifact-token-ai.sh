#!/bin/bash

# User Configuration
user="scott.walter" # Your AWS username
target_profile_name="nice-devops" # Local profile name for credentials
target_account_num="369498121101" # Target account number
role_name="GroupAccess-NICE-Architects" # Role in the target account
source_profile="nice-identity" # Source profile in .aws/credentials
main_iam_acct_num="736763050260" # Main IAM account number
default_region="us-west-2" # Default region

# Constants
MFA_PROFILE_NAME="${source_profile}-mfa-session-codeartifact"
CODEARTIFACT_PROFILE_NAME="default-codeartifact"
token_expiration_seconds=129600 # 36 Hours
mfa_device="arn:aws:iam::$main_iam_acct_num:mfa/$user"
target_role="arn:aws:iam::$target_account_num:role/$role_name"

# Function to get MFA session token
get_mfa_session_token() {
    read -p 'Enter MFA Code: ' mfa_token
    aws sts get-session-token \
        --serial-number "$mfa_device" \
        --duration-seconds "$token_expiration_seconds" \
        --token-code "$mfa_token" \
        --profile "$source_profile" \
        --output json
}

# Function to assume role
assume_role() {
    aws sts assume-role \
        --role-arn "$target_role" \
        --role-session-name "$user" \
        --profile "$MFA_PROFILE_NAME" \
        --query "Credentials" \
        --output json
}

# Function to configure AWS CLI profile
configure_aws_profile() {
    local profile="$1"
    local access_key="$2"
    local secret_key="$3"
    local session_token="$4"

    aws configure set aws_access_key_id "$access_key" --profile "$profile"
    aws configure set aws_secret_access_key "$secret_key" --profile "$profile"
    aws configure set aws_session_token "$session_token" --profile "$profile"
    aws configure set region "$default_region" --profile "$profile"
}

# Function to generate CodeArtifact token
generate_codeartifact_token() {
    aws codeartifact get-authorization-token \
        --domain nice-devops \
        --domain-owner "$target_account_num" \
        --query authorizationToken \
        --output text \
        --region "$default_region" \
        --profile "$CODEARTIFACT_PROFILE_NAME"
}

# Main Script
echo "Obtaining MFA session token..."
mfa_session=$(get_mfa_session_token)
if [ $? -ne 0 ]; then
    echo "Failed to get MFA session token. Exiting."
    exit 1
fi

ACCESS_KEY_ID=$(echo "$mfa_session" | jq -r .Credentials.AccessKeyId)
SECRET_ACCESS_KEY=$(echo "$mfa_session" | jq -r .Credentials.SecretAccessKey)
SESSION_TOKEN=$(echo "$mfa_session" | jq -r .Credentials.SessionToken)

echo "Configuring MFA profile..."
configure_aws_profile "$MFA_PROFILE_NAME" "$ACCESS_KEY_ID" "$SECRET_ACCESS_KEY" "$SESSION_TOKEN"

counter=36
while [ $counter -ge 1 ]; do
    echo "Renewing $target_profile_name access keys..."
    role_creds=$(assume_role)
    if [ $? -ne 0 ]; then
        echo "Failed to assume role. Exiting."
        exit 1
    fi

    ACCESS_KEY_ID=$(echo "$role_creds" | jq -r .AccessKeyId)
    SECRET_ACCESS_KEY=$(echo "$role_creds" | jq -r .SecretAccessKey)
    SESSION_TOKEN=$(echo "$role_creds" | jq -r .SessionToken)

    echo "Configuring CodeArtifact profile..."
    configure_aws_profile "$CODEARTIFACT_PROFILE_NAME" "$ACCESS_KEY_ID" "$SECRET_ACCESS_KEY" "$SESSION_TOKEN"

    echo "Generating CodeArtifact token..."
    CODEARTIFACT_AUTH_TOKEN=$(generate_codeartifact_token)
    if [ $? -ne 0 ]; then
        echo "Failed to generate CodeArtifact token. Exiting."
        exit 1
    fi

    NPMFILE="$HOME/.npmrc"
    echo "Updating .npmrc..."
    cat > "$NPMFILE" <<EOF
registry=https://nice-devops-369498121101.d.codeartifact.us-west-2.amazonaws.com/npm/cxone-npm/
//nice-devops-369498121101.d.codeartifact.us-west-2.amazonaws.com/npm/cxone-npm/:always-auth=true
//nice-devops-369498121101.d.codeartifact.us-west-2.amazonaws.com/npm/cxone-npm/:_authToken=${CODEARTIFACT_AUTH_TOKEN}
EOF

    echo "Updating Maven settings.xml..."
    sed -i "6,16s/<password>/<password>$CODEARTIFACT_AUTH_TOKEN/" ~/.m2/settings.xml

    export CODEARTIFACT_AUTH_TOKEN
    echo "Token updated. Remaining renewal cycles: $counter"
    ((counter--))
    sleep 3540 # 59 minutes
done
