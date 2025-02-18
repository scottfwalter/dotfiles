#!/bin/bash

# Store URLs in a variable using heredoc
urls=$(cat << "URLS"
https://www.example.com
https://www.macrumors.com
https://www.github.com
URLS
)

# Read URLs from the variable and open each in a new browser tab
echo "$urls" | while IFS= read -r url; do
    # Skip empty lines and comments
    [[ -z "$url" || "$url" =~ ^[[:space:]]*# ]] && continue

    # Trim whitespace
    url=$(echo "$url" | xargs)

    # Open URL in default browser
    open "$url"

    # Small delay to prevent overwhelming the system
    sleep 0.5
done
