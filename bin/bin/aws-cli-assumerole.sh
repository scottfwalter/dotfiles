#! /bin/bash
#
# Dependencies:
#   brew install jq
#   sed
#
# Setup:
#   chmod +x ./aws-cli-assumerole.sh
#
# Execute:
#   source ./aws-cli-assumerole.sh
#    -OR-
#   . ./aws-cli-assumerole.sh
#
# Description:
#   Makes assuming an AWS IAM role (+ exporting new temp keys) easier

PROFILE_NAME=${1:-dev} # target profile
IDENTITY_PROFILE=${2:-$(aws configure get source_profile --profile $PROFILE_NAME)}
SESSION_USERNAME=$(echo $USER)
ROLE_ARN="$(aws configure get role_arn --profile ${PROFILE_NAME})"
SERIAL_NUMBER="$(aws configure get mfa_serial --profile ${PROFILE_NAME})"

echo "Enter MFA Code:"
read MFA_TOKEN

#unset these so that defaults are taken from .aws/credentials
unset AWS_SESSION_TOKEN
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY

#echo "ROLE_ARN=$ROLE_ARN" 
#echo "SESSION_USERNAME=$SESSION_USERNAME"
#echo "AWS_REGION=$AWS_REGION"

temp_role=$(aws sts assume-role \
                    --profile ${IDENTITY_PROFILE} \
                    --role-arn "${ROLE_ARN}" \
                    --role-session-name "${SESSION_USERNAME}" \
                    --serial-number "${SERIAL_NUMBER}" \
                    --token-code ${MFA_TOKEN} )

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)
export AWS_DEFAULT_REGION="$(aws configure get region --profile ${PROFILE_NAME})"

env | grep -i AWS_
