#!/bin/bash

# Detect the platform
OS_TYPE=$(uname)

# Define home directory based on platform
if [[ "$OS_TYPE" == "Linux" || "$OS_TYPE" == "Darwin" ]]; then
    HOME_DIR="$HOME"
elif [[ "$OS_TYPE" == "MINGW64_NT"* || "$OS_TYPE" == "CYGWIN_NT"* ]]; then
    # Assume Git Bash or Cygwin on Windows
    HOME_DIR=$(cygpath -u "$USERPROFILE")
else
    echo "Unsupported OS type: $OS_TYPE"
    exit 1
fi

ENVIRONMENT=$1
PLAYBOOK_COMMAND=$2

# Extract AWS region from the environment string
AWS_REGION=$(echo $ENVIRONMENT | awk -F "-" '{print $2"-"$3"-"$4}')

# Construct the path to the JSON file and password file
JSON_FILE="${HOME_DIR}/trade-feed-etl-health-checker_${AWS_REGION}_${ENVIRONMENT}.json"
PASSWORD_FILE="${HOME_DIR}/trade-feed-etl-health-checker_${AWS_REGION}_${ENVIRONMENT}/password.enc"

# Check if the JSON file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "JSON configuration file not found: $JSON_FILE"
    exit 1
fi

# Check if the password file exists
if [ ! -f "$PASSWORD_FILE" ]; then
    echo "Password file not found: $PASSWORD_FILE"
    exit 1
fi

# Load the key and password from the JSON file
KEY=$(jq -r ".key" "$JSON_FILE")
PASSWORD=$(jq -r ".password" "$JSON_FILE")

# Validate the password by decrypting the password file and comparing
echo -n "$PASSWORD" | openssl enc -aes-256-cbc -d -a -salt -pass pass:"$KEY" -in "$PASSWORD_FILE" | grep -q "$PASSWORD"

if [ $? -ne 0 ]; then
    echo "Password validation failed."
    exit 1
fi

# Run the Ansible playbook with the appropriate environment and region
ansible-playbook -e "aws_region=${AWS_REGION} environment=${ENVIRONMENT} json_file_path=${JSON_FILE}" $PLAYBOOK_COMMAND
