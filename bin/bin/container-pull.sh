#!/bin/bash

set -x
echo $TERM_PROGRAM
PROFILE_NAME="nice-devops"
AWS_ECR_REGION="us-west-2"
AWS_ECR_ACCOUNT_NUMBER="369498121101"
DOCKER_IMAGE="platform-frontend:1.80.0"

# aws ecr get-login-password --profile ${PROFILE_NAME} --region ${AWS_ECR_REGION} |
#     container registry login --username AWS --password-stdin ${AWS_ECR_ACCOUNT_NUMBER}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com

password=$(aws ecr get-login-password --profile ${PROFILE_NAME} --region ${AWS_ECR_REGION})
#echo $password
echo $password | container registry login --username AWS --password-stdin ${AWS_ECR_ACCOUNT_NUMBER}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com
sleep 2
container images pull ${AWS_ECR_ACCOUNT_NUMBER}.dkr.ecr.${AWS_ECR_REGION}.amazonaws.com/${DOCKER_IMAGE}
