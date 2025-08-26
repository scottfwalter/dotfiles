#! /bin/bash

# Script to backup and update AWS credentials
# Usage: ./update_aws_creds.sh <access-key> <secret-key>

set -e # Exit on any error

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <access-key> <secret-key>"
    echo "Example: $0 AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    exit 1
fi

ACCESS_KEY="$1"
SECRET_KEY="$2"
CREDENTIALS_FILE="$HOME/.aws/credentials"

# Check if credentials file exists
if [ ! -f "$CREDENTIALS_FILE" ]; then
    echo "Error: AWS credentials file not found at $CREDENTIALS_FILE"
    exit 1
fi

# Create backup with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${CREDENTIALS_FILE}.backup_${TIMESTAMP}"

echo "Creating backup: $BACKUP_FILE"
cp "$CREDENTIALS_FILE" "$BACKUP_FILE"

# Function to update a profile section
update_profile() {
    local profile_name="$1"
    local temp_file=$(mktemp)
    local in_target_section=false
    local section_found=false

    while IFS= read -r line; do
        # Check if we're entering the target section
        if [[ "$line" =~ ^\[${profile_name}\]$ ]]; then
            in_target_section=true
            section_found=true
            echo "$line" >>"$temp_file"
            continue
        fi

        # Check if we're entering a different section
        if [[ "$line" =~ ^\[.*\]$ ]] && [ "$in_target_section" = true ]; then
            in_target_section=false
        fi

        # Update keys if we're in the target section
        if [ "$in_target_section" = true ]; then
            if [[ "$line" =~ ^aws_access_key_id ]]; then
                echo "aws_access_key_id = $ACCESS_KEY" >>"$temp_file"
            elif [[ "$line" =~ ^aws_secret_access_key ]]; then
                echo "aws_secret_access_key = $SECRET_KEY" >>"$temp_file"
            else
                echo "$line" >>"$temp_file"
            fi
        else
            echo "$line" >>"$temp_file"
        fi
    done <"$CREDENTIALS_FILE"

    # If section wasn't found, add it at the end
    if [ "$section_found" = false ]; then
        echo "" >>"$temp_file"
        echo "[$profile_name]" >>"$temp_file"
        echo "aws_access_key_id = $ACCESS_KEY" >>"$temp_file"
        echo "aws_secret_access_key = $SECRET_KEY" >>"$temp_file"
    fi

    mv "$temp_file" "$CREDENTIALS_FILE"
}

# Update each profile
PROFILES=("default" "nice-identity" "dev")

echo "Updating AWS credentials..."
for profile in "${PROFILES[@]}"; do
    echo "Updating profile: [$profile]"
    update_profile "$profile"
done

echo "Successfully updated AWS credentials!"
echo "Backup saved as: $BACKUP_FILE"
echo ""
echo "Updated profiles:"
for profile in "${PROFILES[@]}"; do
    echo "  - $profile"
done
