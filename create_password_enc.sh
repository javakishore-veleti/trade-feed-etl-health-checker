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

# Prompt the user for the encryption key and password
read -sp "Enter the encryption key: " encryption_key
echo
read -sp "Enter the password to encrypt: " password
echo

# Create the encrypted password file for each environment
for i in "${!environments[@]}"; do
    env="${environments[$i]}"
    region="${regions[$i]}"
    dir_path="${HOME_DIR}/trade-feed-etl-health-checker_${region}_${env}"

    # Ensure the directory exists
    mkdir -p "$dir_path"

    # Define the path to the password.enc file
    file_path="${dir_path}/password.enc"

    # Encrypt the password and save it to the password.enc file
    echo -n "$password" | openssl enc -aes-256-cbc -a -salt -pass pass:"$encryption_key" -out "$file_path"

    echo "Created encrypted password file: $file_path"
done
