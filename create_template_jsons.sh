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

# Define environments and regions
environments=("dev-us-east-1" "qa-eu-west-1" "prod-ap-south-1")
regions=("us-east-1" "eu-west-1" "ap-south-1")

# Template content without lambda_function_arn
template_content='{
  "aws_access_key_id": "your-access-key-id",
  "aws_secret_access_key": "your-secret-access-key",
  "ses_email": "your-email@example.com",
  "key": "your-encryption-key",
  "password": "your-password"
}'

# Create template JSON files
for i in "${!environments[@]}"; do
    env="${environments[$i]}"
    region="${regions[$i]}"
    file_path="${HOME_DIR}/trade-feed-etl-health-checker_${region}_${env}.json"
    
    # Check if the file already exists
    if [ ! -f "$file_path" ]; then
        # File does not exist, create it
        echo "$template_content" > "$file_path"
        echo "Created template file: $file_path"
    else
        # File already exists, skip creation
        echo "File already exists: $file_path"
    fi
done
