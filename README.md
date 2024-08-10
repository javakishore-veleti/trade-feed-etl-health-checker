# trade-feed-etl-health-checker
trade-feed-etl-health-checker is a comprehensive infrastructure automation solution designed to manage and monitor the ETL (Extract, Transform, Load) processes for trade feed data across multiple environments. This repository includes a set of Ansible playbooks and associated scripts to securely deploy, manage, and terminate the ETL infrastructure in various environments such as Dev, QA, Prod, and others.

The repository implements security controls that require password validation before executing any infrastructure-related operations. The passwords are securely encrypted, and an AWS profile is used to ensure that operations are environment-specific.

##
```shell
# Ensure that jq is installed on the machine where the script will run. jq is a lightweight and flexible command-line JSON processor.

sudo apt-get install jq   # For Debian/Ubuntu
brew install jq           # For macOS
choco install jq          # For Windows

```

# Key Features
### Environment-Specific Infrastructure: 
Supports multiple environments (Dev, QA, Prod, Pre-Prod, Demo) with separate configurations for each.

### Secure Operations: 
All operations require password validation, with passwords stored securely using encryption.

### AWS Profile Integration: 
Uses AWS CLI profiles prefixed with trade-feed-etl to manage resources in different AWS environments.

### Automated Setup and Termination: 
Includes playbooks for setting up and tearing down the ETL infrastructure, including PostgreSQL databases, AWS EventBridge, AWS Lambda, and AWS SES.

### Test Data Generation: 
Playbooks to generate test data for the trade feed ETL processes.

### Controlled Execution via npm: 
All playbooks and scripts are executed via npm scripts, allowing for consistent and controlled operations.

## Project Structure
trade-feed-etl-health-checker/
├── envs/
│   ├── dev.yml                # Environment-specific configuration files
│   ├── qa.yml
│   ├── prod.yml
│   ├── ...
├── run_protected_playbook.sh  # Shell script to validate password and execute Ansible playbooks
├── validate_pwd_for_ansible_pb_run.py  # Python script to validate password encryption
├── package.json               # npm scripts for executing playbooks
├── README.md                  # Project documentation

## Directory Overview
envs/: This directory contains environment-specific configuration files. Each file includes settings unique to a particular environment (Dev, QA, Prod, etc.), such as database names, credentials, and AWS configurations.

run_protected_playbook.sh: This is a shell script responsible for executing Ansible playbooks. It ensures that operations are secure by requiring password validation before running any playbooks. The script takes the environment, playbook command, AWS profile, encryption key, and password as inputs.

validate_pwd_for_ansible_pb_run.py: This Python script is used by the shell script to validate passwords. It decrypts the stored, encrypted password and compares it with the user input to ensure secure operations.

package.json: This file contains npm scripts that are used to run the Ansible playbooks across different environments. The npm scripts provide a convenient and consistent way to manage infrastructure across all environments.

## Prerequisites
- Ansible: Ensure Ansible is installed on your machine.
- Python 3: Required for running the password validation script.
- AWS CLI: Configured with profiles prefixed by trade-feed-etl for different environments.
- npm: Used to run the scripts defined in package.json.

## Installation and Setup
1. Clone the Repository:
   
2. Set Up Environment Files:

- Update or create environment-specific files in the envs/ directory.
- Ensure that each environment has a corresponding encrypted password file.

## Configure AWS Profiles:

Set up AWS CLI profiles prefixed with trade-feed-etl (e.g., trade-feed-etl-dev, trade-feed-etl-qa, etc.).
Each profile should be configured with credentials for the respective AWS environment.

## Usage
- Running Ansible Playbooks
- Each environment has its own set of npm commands to execute the necessary infrastructure operations.

-- Example: Setting Up the PostgreSQL Database in Dev

npm run trade-feed-dl-db-setup:dev -- trade-feed-etl-dev-profile <key-for-dev-environment> <your-password>

-- Example: Generating Test Data in QA
npm run trade-feed-test-data-generate:qa -- trade-feed-etl-qa-profile <key-for-qa-environment> <your-password>

-- Example: Terminating Infrastructure in Production

npm run trade-feed-dl-db-terminate:prod -- trade-feed-etl-prod-profile <key-for-prod-environment> <your-password>

## Security Considerations
Password Encryption: Passwords are stored in encrypted files in the envs/ directory. The encryption key must be passed as a command-line argument during playbook execution.
AWS Profiles: Each operation is tied to a specific AWS profile to ensure that actions are only performed in the intended environment.
