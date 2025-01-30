#!/bin/bash

# Script to check if a user is a member of a GitHub team
# Usage: ./check_team_membership.sh <org> <team_slug> <username> <github_token>

# Function to display usage
usage() {
    echo "Usage: $0 <organization> <team_slug> <username> <github_token>"
    echo "Example: $0 myorg backend-team johndoe ghp_1234567890abcdef"
    exit 1
}

# Check if all required arguments are provided
if [ $# -ne 4 ]; then
    usage
fi

# Assign arguments to variables
ORG=$1
TEAM_SLUG=$2
USERNAME=$3
TOKEN=$4

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to handle errors
handle_error() {
    local status_code=$1
    local error_message=$2

    case $status_code in
        404)
            echo -e "${RED}Error: Team or user not found${NC}"
            ;;
        401)
            echo -e "${RED}Error: Authentication failed. Check your token${NC}"
            ;;
        403)
            echo -e "${RED}Error: Insufficient permissions${NC}"
            ;;
        *)
            echo -e "${RED}Error: $error_message${NC}"
            ;;
    esac
    exit 1
}

# Make API request to check team membership
echo "Checking if $USERNAME is a member of $TEAM_SLUG in $ORG..."

response=$(curl -s -w "\n%{http_code}" \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/orgs/$ORG/teams/$TEAM_SLUG/memberships/$USERNAME")

# Get status code from last line
http_code=$(echo "$response" | tail -n1)
# Get response body (remove status code line)
body=$(echo "$response" | sed '$d')

# Check response
if [ "$http_code" -eq 200 ]; then
    # Parse state from response
    state=$(echo "$body" | grep -o '"state": "[^"]*"' | cut -d'"' -f4)

    if [ "$state" = "active" ]; then
        echo -e "${GREEN}✓ $USERNAME is an active member of $TEAM_SLUG${NC}"
        exit 0
    elif [ "$state" = "pending" ]; then
        echo -e "${RED}! $USERNAME has a pending invitation to $TEAM_SLUG${NC}"
        exit 2
    fi
else
    handle_error "$http_code" "$body"
fi
