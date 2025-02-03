#!/bin/bash

ORG="nice-cxone"
echo $GITHUB_TOKEN
total_teams=0
current_page=1
all_teams=()

while true; do

	if [ $current_page -ge 5 ]; then
		echo "Processed more pages ($current_page) than I was expecting. Please review script."
		exit 1
	fi

	API_URL="https://api.github.com/orgs/${ORG}/teams?page=${current_page}&per_page=100"
	response=$(curl -s -w "HTTPSTATUS:%{http_code}" -H "Authorization: token ${GITHUB_TOKEN}" \
                   -H "Accept: application/vnd.github.v3+json" \
                   "${API_URL}")

	response_code=$(echo $response | sed -n 's/.*\(HTTPSTATUS:.*\)/\1/p' | sed 's/^HTTPSTATUS://')
	response_body=$(echo $response | sed 's/HTTPSTATUS:.*//')
	teams_count=$(echo $response_body | jq 'length')
	total_teams=$((total_teams + teams_count))

	teams=$(echo "$response_body" | jq -r '.[].name')
    	teams=$(echo "$response_body" | jq -r '.[] | "\(.name),\(.url)"')
	if [ -n "$teams" ]; then
		while IFS= read -r team; do
			all_teams+=("$team")
		done <<< "$teams"
	fi


	if [ $teams_count -eq 100 ]; then
	  current_page=$((current_page + 1))
	else
          break

        fi
done

printf '%s\n' "${all_teams[@]}" | sort --ignore-case

