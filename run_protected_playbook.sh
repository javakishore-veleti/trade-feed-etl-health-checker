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
TABLE_NAME=$3 # Optional third argument for table name

# Extract AWS region from the environment string
AWS_REGION=$(echo $ENVIRONMENT | awk -F "-" '{print $2"-"$3"-"$4}')

# Construct the path to the JSON file and password file
JSON_FILE="${HOME_DIR}/trade-feed-etl-health-checker_${AWS_REGION}_${ENVIRONMENT}.json"
PASSWORD_FILE="${HOME_DIR}/trade-feed-etl-health-checker_${AWS_REGION}_${ENVIRONMENT}/password.enc"

# Check if the JSON file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "ERROR: JSON configuration file not found: $JSON_FILE"
    echo "Make sure the file exists and is correctly named."
    exit 1
fi

# Check if the password file exists
if [ ! -f "$PASSWORD_FILE" ]; then
    echo "ERROR: Password file not found: $PASSWORD_FILE"
    echo "Make sure the password.enc file is present in the correct directory."
    exit 1
fi

# Load the key and password from the JSON file
KEY=$(jq -r ".key" "$JSON_FILE")
PASSWORD=$(jq -r ".password" "$JSON_FILE")

# Check if the key and password were extracted correctly
if [ -z "$KEY" ]; then
    echo "ERROR: Encryption key not found in $JSON_FILE"
    echo "Make sure the 'key' field is present and correctly set."
    exit 1
fi

if [ -z "$PASSWORD" ]; then
    echo "ERROR: Password not found in $JSON_FILE"
    echo "Make sure the 'password' field is present and correctly set."
    exit 1
fi

# Read the stored password from the password.enc file
STORED_PASSWORD=$(cat "$PASSWORD_FILE")

# Compare the stored password with the password from the JSON file
if [ "$STORED_PASSWORD" != "$PASSWORD" ]; then
    echo "ERROR: Password validation failed."
    echo "Possible reasons and fixes:"
    echo "- The password in the JSON file (${JSON_FILE}) does not match the password stored in ${PASSWORD_FILE}."
    echo "  FIX: Open the JSON file and verify that the 'password' field matches the password stored in the password.enc file."
    echo "- The password.enc file (${PASSWORD_FILE}) was not created using the password in the JSON file."
    echo "  FIX: Recreate the password.enc file using the 'npm run create-password-enc' command, ensuring that the password in the JSON file matches."
    exit 1
else
    echo "Password validation succeeded."
fi

# Correctly structure the ansible-playbook command with table name if provided
if [ -z "$TABLE_NAME" ]; then
    ANSIBLE_CMD="ansible-playbook -e aws_region=${AWS_REGION} -e environment=${ENVIRONMENT} -e json_file_path=${JSON_FILE} $PLAYBOOK_COMMAND -vvv"
else
    ANSIBLE_CMD="ansible-playbook -e aws_region=${AWS_REGION} -e environment=${ENVIRONMENT} -e json_file_path=${JSON_FILE} -e table_name=${TABLE_NAME} $PLAYBOOK_COMMAND -vvv"
fi

# Execute the ansible-playbook command
echo "Running: $ANSIBLE_CMD"
$ANSIBLE_CMD
