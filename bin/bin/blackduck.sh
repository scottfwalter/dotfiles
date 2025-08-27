#! /bin/bash
set -x
API_KEY=$(op item get "Black Duck" --fields "API Key")
PROJECT_NAME="cxone-hybrid-webapp-boilerplate"
bash <(curl -s -L https://detect.blackduck.com/detect10.sh) --blackduck.url=https://nice2.app.blackduck.com --blackduck.api.token=$API_KEY --detect.project.name="$PROJECT_NAME" --detect.project.version.name="9.0.0"
