# trade-feed-etl-health-checker

**trade-feed-etl-health-checker** is an automated infrastructure management solution designed to handle trade feed ETL (Extract, Transform, Load) processes across multiple environments, including Dev, QA, and Prod. This repository provides Ansible playbooks and scripts for deploying, managing, and terminating ETL infrastructure on AWS, with built-in security features like password validation and environment-specific AWS profiles.

## Key Features

- **Environment-Specific Infrastructure**: Supports multiple environments (Dev, QA, Prod, etc.), each with its own configuration.
- **Secure Operations**: Passwords and encryption keys are securely stored in a JSON file in the user's home directory and are validated before executing operations.
- **AWS Profile Integration**: Automatically loads AWS profiles from environment-specific YAML files stored within each environment's directory.
- **Automated Setup and Termination**: Includes playbooks for setting up and tearing down PostgreSQL databases, AWS EventBridge, AWS Lambda, and AWS SES.
- **Test Data Generation**: Playbooks to generate test data for trade feed ETL processes.
- **Controlled Execution via npm**: All playbooks and scripts are executed via npm scripts, allowing for consistent and controlled operations.

## Directory Overview

- **`envs/`**: Contains subdirectories for each environment (e.g., `dev`, `prod`, `qa`). Each subdirectory contains:
  - **`password.enc`**: The encrypted password file for the environment.
  - **`<environment>.yml`**: The configuration file for the environment.
- **`playbooks/`**: Includes Ansible playbooks for setting up and managing infrastructure components like PostgreSQL, AWS services, and more.
- **`run_protected_playbook.sh`**: A shell script that securely executes Ansible playbooks after validating the password and loading the correct AWS profile.
- **`validate_pwd_for_ansible_pb_run.py`**: A Python script that validates the password against encrypted data stored in the environment files.
- **`package.json`**: Defines npm scripts to execute the playbooks and manage infrastructure across different environments.

## Prerequisites

- **Git Bash or PowerShell**: For running shell scripts on Windows, use Git Bash or PowerShell.
- **jq**: A lightweight JSON processor required for parsing JSON in shell scripts. Install via your package manager (e.g., `choco install jq` for Windows).
- **Ansible**: Ensure Ansible is installed on your system for running the playbooks.
- **Python 3**: Required for running the password validation script.
- **AWS CLI**: Set up with the necessary profiles, each prefixed with `trade-feed-etl` for different environments.
- **npm**: Used to run the scripts defined in `package.json`.

## Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/javakishore-veleti/trade-feed-etl-health-checker.git
   cd trade-feed-etl-health-checker

##
```shell
# Ensure that jq is installed on the machine where the script will run. jq is a lightweight and flexible command-line JSON processor.

sudo apt-get install jq   # For Debian/Ubuntu
brew install jq           # For macOS
choco install jq          # For Windows

 mkdir -p envs/dev
 mkdir -p envs/prod
 mkdir -p envs/qa  
 mkdir -p envs/pre-prod
 mkdir -p envs/demo

 touch envs/dev/dev.yml
 touch envs/prod/prod.yml
 touch envs/qa/qa.yml
 touch envs/pre-prod/pre-prod.yml
 touch envs/demo/demo.yml

 echo -n "your-dev-password" | openssl enc -aes-256-cbc -a -salt -pass pass:your-encryption-key -out envs/dev/password.enc

 echo -n "your-prod-password" | openssl enc -aes-256-cbc -a -salt -pass pass:your-encryption-key -out envs/prod/password.enc

echo -n "your-qa-password" | openssl enc -aes-256-cbc -a -salt -pass pass:your-encryption-key -out envs/qa/password.enc

echo -n "your-pre-prod-password" | openssl enc -aes-256-cbc -a -salt -pass pass:your-encryption-key -out envs/pre-prod/password.enc

echo -n "your-demo-password" | openssl enc -aes-256-cbc -a -salt -pass pass:your-encryption-key -out envs/demo/password.enc


touch ~/trade-feed-etl-health-checker.json

sudo apt-get install jq      # For Ubuntu/Debian
brew install jq              # For macOS
choco install jq             # For Windows (via Git Bash or PowerShell)

sudo apt-get install ansible   # For Ubuntu/Debian
brew install ansible           # For macOS
choco install ansible          # For Windows (via WSL or Cygwin)

sudo apt-get install awscli    # For Ubuntu/Debian
brew install awscli            # For macOS
choco install awscli           # For Windows

sudo apt-get install npm       # For Ubuntu/Debian
brew install npm               # For macOS


```



