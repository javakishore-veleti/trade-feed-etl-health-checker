#!/bin/bash

# Define paths and variables
ENVIRONMENT=$1
PLAYBOOK_COMMAND=$2
AWS_PROFILE=$3
KEY=$4
PASSWORD=$5
ENCRYPTED_PASSWORD_FILE="envs/$ENVIRONMENT/password.enc"

# Export the AWS profile for the session
export AWS_PROFILE=$AWS_PROFILE

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
