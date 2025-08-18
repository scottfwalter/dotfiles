#! /bin/bash

export AWS_BEARER_TOKEN_BEDROCK=$(op item get "AWS: nice-identity" --fields "Bedrock API Key")
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-west-2
export ANTHROPIC_MODEL='us.anthropic.claude-sonnet-4-20250514-v1:0'
#export ANTHROPIC_MODEL='us.anthropic.claude-opus-4-20250514-v1:0'
