#!/bin/sh

# Define paths and variables
ENVIRONMENT=$1
PLAYBOOK_COMMAND=$2
ENCRYPTED_PASSWORD_FILE="envs/$ENVIRONMENT/password.enc"
ENV_FILE="envs/$ENVIRONMENT/$ENVIRONMENT.yml"

# Load AWS profile from the environment file
AWS_PROFILE=$(grep 'aws_profile' "$ENV_FILE" | awk -F ": " '{print $2}')

# Export the AWS profile for the session
export AWS_PROFILE=$AWS_PROFILE

# Load key and password from JSON file in user's home directory
JSON_FILE="$HOME/trade-feed-etl-health-checker.json"
KEY=$(jq -r ".${ENVIRONMENT}.key" "$JSON_FILE")
PASSWORD=$(jq -r ".${ENVIRONMENT}.password" "$JSON_FILE")

# Validate the password
python3 validate_pwd_for_ansible_pb_run.py "$PASSWORD" "$ENCRYPTED_PASSWORD_FILE" "$KEY"

# Check if password validation was successful
if [ $? -eq 0 ]; then
    echo "Password validated successfully. Running Ansible playbook..."
    eval "$PLAYBOOK_COMMAND"
else
    echo "Failed to validate password. Aborting..."
    exit 1
fi
