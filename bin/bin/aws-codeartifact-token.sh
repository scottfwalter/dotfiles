#!/bin/bash

# AWS IAM user and config target_profile to use
user="scott.walter" # Your AWS username
target_profile_name="nice-devops" # This is the local profile name you use to when accessing these credentials (e.g., dev, test-nvir, etc.)
target_account_num="369498121101" # This is the account number of the account alias you want to access (e.g., 934137132601 is for dev. See table below for more)
role_name="GroupAccess-NICE-Architects" # Your role in the target account
#source_profile="default" # This is your profile name as you configured it in .aws/credentials
source_profile="nice-identity" # This is your profile name as you configured it in .aws/credentials
main_iam_acct_num="736763050260" # This should be the nice-identity account number
default_region="us-west-2" # Default region for where your CLI session lives (e.g., us-west-2 for dev, us-east-1 for test-nvir etc.)

echo "########################### DO NOT EDIT ANYTHING BELOW THIS LINE ###############"

echo "**********************************************************************************"
echo "This script will obtain temporary credentials for $target_profile_name and store them"
echo "in your AWS CLI configuration. This will allow certain programs (e.g., IntelliJ IDEA)"
echo "to access $target_profile_name through your $source_profile account."
echo "**********************************************************************************"

# Get MFA token from user
mfa_device="arn:aws:iam::$main_iam_acct_num:mfa/$user"
read -p 'Enter MFA Code: ' mfa_token
token_expiration_seconds=129600 # 36 Hours

# Piece together role information
target_role="arn:aws:iam::$target_account_num:role/$role_name"

# Variable to hold AccessKeyId, SecretAccessKey, and SessionToken returned
# from 'aws sts assume-role' command.
MFA_PROFILE_NAME="${source_profile}-mfa-session-codeartifact"

echo "aws sts get-session-token --serial-number $mfa_device --duration-seconds $token_expiration_seconds --token-code $mfa_token --profile $source_profile"
token_creds=`aws sts get-session-token --serial-number $mfa_device --duration-seconds $token_expiration_seconds --token-code $mfa_token --profile $source_profile`

# Check if aws command executed successfully
if [ $? -eq 0 ];
then
    ACCESS_KEY_ID=$(echo $token_creds | jq .Credentials.AccessKeyId | xargs)
    SECRET_ACCESS_KEY=$(echo $token_creds | jq .Credentials.SecretAccessKey | xargs)
    SESSION_TOKEN=$(echo $token_creds | jq .Credentials.SessionToken | xargs)
    # Set AWS credentials via CLI
    aws configure set aws_access_key_id $ACCESS_KEY_ID --profile "${MFA_PROFILE_NAME}"
    aws configure set aws_secret_access_key $SECRET_ACCESS_KEY --profile "${MFA_PROFILE_NAME}"
    aws configure set aws_session_token $SESSION_TOKEN --profile "${MFA_PROFILE_NAME}"
    aws configure set region $default_region --profile $target_profile_name

    echo "Successfully cached token for $token_expiration_seconds seconds."
fi

    counter=36
    while [ $counter -ge 1 ]
do

    echo "Renewing $target_profile_name access keys..."
    creds=`aws sts assume-role --role-arn $target_role --role-session-name $user --profile "${MFA_PROFILE_NAME}" --query "Credentials"`

    # Check if aws command executed successfully
if [ $? -eq 0 ];
then
    CODEARTIFACT_PROFILE_NAME="default-codeartifact"
    ACCESS_KEY_ID=$(echo $creds | jq -r .AccessKeyId | xargs)
    SECRET_ACCESS_KEY=$(echo $creds | jq -r .SecretAccessKey | xargs)
    SESSION_TOKEN=$(echo $creds | jq -r .SessionToken | xargs)
    # Set AWS credentials via CLI
    aws configure set aws_access_key_id $ACCESS_KEY_ID --profile "${CODEARTIFACT_PROFILE_NAME}"
    aws configure set aws_secret_access_key $SECRET_ACCESS_KEY --profile "${CODEARTIFACT_PROFILE_NAME}"
    aws configure set aws_session_token $SESSION_TOKEN --profile "${CODEARTIFACT_PROFILE_NAME}"
    aws configure set region $default_region --profile "${CODEARTIFACT_PROFILE_NAME}"

    echo "$target_profile_name profile has been updated in ~/.aws/credentials."
	echo ""
    echo "Generating codeArtifact Token."
    CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain nice-devops --domain-owner 369498121101 --query authorizationToken --output text --region us-west-2 --profile "${CODEARTIFACT_PROFILE_NAME}"`


    NPMFILE="$HOME/.npmrc"
    rm "$NPMFILE"
    echo "registry=https://nice-devops-369498121101.d.codeartifact.us-west-2.amazonaws.com/npm/cxone-npm/" >> $NPMFILE
    echo "//nice-devops-369498121101.d.codeartifact.us-west-2.amazonaws.com/npm/cxone-npm/:always-auth=true" >> $NPMFILE
    echo "//nice-devops-369498121101.d.codeartifact.us-west-2.amazonaws.com/npm/cxone-npm/:_authToken=${CODEARTIFACT_AUTH_TOKEN}" >> $NPMFILE
    echo "Upating Token in settings.xml"
    echo $CODEARTIFACT_AUTH_TOKEN
	sed -i "6,16s/<password>/<password>$CODEARTIFACT_AUTH_TOKEN/" ~/.m2/settings.xml
	 export CODEARTIFACT_AUTH_TOKEN
	  if [ $counter -eq 1 ]; then
            echo "Keep this window open to have your keys renewed every 59 minutes for the next $counter hour."
       else
            echo "Keep this window open to have your keys renewed every 59 minutes for the next $counter hours."
       fi
 fi
 ((counter--))
  sleep 3540 # 59 minutes
 done