  echo "Please enter your MFA code"
  read -r MFA_CODE

echo $MFA_CODE
RES=$(aws sts get-session-token --serial-number arn:aws:iam::736763050260:mfa/scott.walter --token-code $MFA_CODE)
if [[ $? -ne 0 ]]; then
  echo "Retrieving session failed! 🛑"
  exit 1
fi

KEY=$(echo $RES | jq -r .Credentials.AccessKeyId)
SECRET=$(echo $RES | jq -r .Credentials.SecretAccessKey)
SESSION=$(echo $RES | jq -r .Credentials.SessionToken)

echo $RES
echo $KEY
echo $SECRET
echo $SESSION

export AWS_ACCESS_KEY_ID=$KEY
export AWS_SECRET_ACCESS_KEY=$SECRET
export AWS_SESSION_TOKEN=$SESSION

echo "Blah"
echo $AWS_ACCESS_KEY_ID



