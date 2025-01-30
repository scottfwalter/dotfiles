#! /bin/bash

#!/bin/bash

# GitHub configuration
ORG="nice-cxone"
API_URL="https://api.github.com/orgs/${ORG}/teams"
PER_PAGE=100

# Check if GITHUB_TOKEN is set
if [ -z "${GITHUB_TOKEN}" ]; then
    echo "Error: GITHUB_TOKEN environment variable is not set"
    echo "Please set it using: export GITHUB_TOKEN='your_token_here'"
    exit 1
fi

# Function to extract next page URL from Link header
get_next_page() {
    local header="$1"
    if echo "$header" | grep -q 'rel="next"'; then
        echo "$header" | grep -o '<[^>]*>' | grep 'rel="next"' -B 1 | head -1 | tr -d '<>'
    else
        echo ""
    fi
}

# Initialize variables
page=1
has_more=true
all_teams=()

# Fetch all pages
while $has_more; do
    #echo "Fetching page $page..."

    # Make API request with pagination
    response=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" \
                   -H "Accept: application/vnd.github.v3+json" \
                   "${API_URL}?per_page=${PER_PAGE}&page=${page}")

#echo "response $response"

    # Check for errors
    #if echo "$response" | jq -e '.message' >/dev/null; then
    #    error_message=$(echo "$response" | jq -r '.message')
    #    echo "Error: $error_message"
    #    exit 1
    #fi

    # Store teams from current page
    teams=$(echo "$response" | jq -r '.[].name')
    teams=$(echo "$response" | jq -r '.[] | "\(.name),\(.url)"')
    if [ -n "$teams" ]; then
        while IFS= read -r team; do
            all_teams+=("$team")
        done <<< "$teams"
    fi

    # Check for next page in Link header
    link_header=$(curl -s -I -H "Authorization: token ${GITHUB_TOKEN}" \
                      -H "Accept: application/vnd.github.v3+json" \
                      "${API_URL}?per_page=${PER_PAGE}&page=${page}" | grep -i "^link:")

#echo "$link_header"

    #next_page=$(get_next_page "$link_header")
    #next_page=$(echo $link_header | sed -n 's/.*page=\([0-9]\+\).*rel="next".*/\1/p')
    next_page=` echo $link_header | gsed -n 's/.*page=\([0-9]\+\).*rel="next".*/\1/p'`
#    echo "next $next_page"

    if [ -z "$next_page" ]; then
        has_more=false
    else
        ((page++))
    fi
done

# Print results
#echo -e "\nFound ${#all_teams[@]} teams in ${ORG}:"
printf '%s\n' "${all_teams[@]}" | sort

