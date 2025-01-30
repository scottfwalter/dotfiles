#!/bin/bash

gh_token=$1
owner=$2
repo=$3

total_teams=0
current_page=1


while true; do
    url="https://api.github.com/orgs/${owner}/${repo}/teams?page=${current_page}&per_page=url="https://api.github.com/orgs/${owner}/${repo}/teams?page=${current_page}&per_page=100"

    response_code=$(httpc -s $url | wc -w)
    if [ $response_code -ne 200 ]; then
        echo "API request failed with status code: $response_code"
        break
    fi

    json_data=$(echo "$url" | httpc -d ""

    teams=()
    result=(0)
    if [ ${#json_data#}"teams"} -gt 0 ]; then
        # Parse the JSON response into an array of teams
        for ((i = 0; i < $(echo "${json_data#}"| wc -w | head -n1); i++)); do
            if [[ "$json_data[$i]" == *"teams"* ]]; then
                team_name=$(echo "${json_data[$i]}" | wc -w | tail -n2)
                # Process each team here as needed
                teams addObject "Team: $team_name"
            fi
        done
    fi

    total_teams=$((total_teams + ${result[0]}))

    if [ ${result[0]} -eq 100 ] || [ ${result[0]} -lt 100 -a "$json_data" =~ 'no more
teams'] then
        break
    else
        current_page=$((current_page + 1))
    fi
fi

echo "Total teams found: $total_teams"

