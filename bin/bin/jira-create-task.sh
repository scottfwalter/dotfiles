#! /bin/bash

read -p "Task description: " task_description


JIRA_TOKEN=ATATT3xFfGF0z0k-pXnOKkvsRWIwZp83z7NKnmgEEa9VvXTTQuJ2NbDUynGcF4h8IQ_0d7KITWyFiHXu_jwyiWdCbq_bDoJ86tZLyvO4fB3VsxHSqKT_vYMZTJxocuaqM8xL4TB_HO9QRc-_QmtYrcJffTJ_Xld0gnK5hAOmvUGDMsCbDakj_mU=C0BA2F3F

project_id=$(curl --request GET \
--url 'https://nice-ce-cxone-prod.atlassian.net/rest/api/3/project/CXAPP' \
--user scott.walter@nice.com:$JIRA_TOKEN \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' | jq -r '.id')

task_type_id=$(curl --request GET \
--url 'https://nice-ce-cxone-prod.atlassian.net/rest/api/3/issuetype' \
--user scott.walter@nice.com:$JIRA_TOKEN \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' | \
jq -r 'map(select(.name == "Task")) | .[0].id')

priority_id=$(curl --request GET \
--url 'https://nice-ce-cxone-prod.atlassian.net/rest/api/3/priority' \
--user scott.walter@nice.com:$JIRA_TOKEN \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' | \
jq -r 'map(select(.name | contains("None"))) | .[0].id')

# echo "results"
# echo $project_id
# echo $task_type_id
# echo $priority_id


generate_post_data() {
cat <<EOF
{"fields":{"project":{"id":"${project_id}"},"issuetype":{"id":"${task_type_id}"},"summary":"${task_description}","assignee":{"id":"557058:2ffba45e-7b8f-4063-b47f-84984990b6b6"},"labels":["JediMasterScott"]}}}
EOF
}

generate_post_data

curl --request POST \
--url 'https://nice-ce-cxone-prod.atlassian.net/rest/api/3/issue' \
--user scott.walter@nice.com:$JIRA_TOKEN \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data "$(generate_post_data)"
