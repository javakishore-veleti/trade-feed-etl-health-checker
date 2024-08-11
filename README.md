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

## Getting Started for Users

If you're a user of the `trade-feed-etl-health-checker` codebase, follow these steps to set up your environment and start using the tools provided:

### 1. **Ensure Required Tools Are Installed**

Before you start, make sure you have the necessary tools installed on your system:

- **jq**: A lightweight JSON processor.
- **Ansible**: For running the playbooks.
- **Python 3**: Required for password validation.
- **AWS CLI**: For interacting with AWS services.
- **npm**: For managing and executing scripts.

Refer to the "Prerequisites" section in this `README.md` for installation instructions specific to your operating system.

### 2. **Configure the JSON File in Your Home Directory**

Create a JSON file named `trade-feed-etl-health-checker.json` in your home directory. This file stores the encryption keys and passwords for each environment:

```bash
touch ~/trade-feed-etl-health-checker.json

```

Add the following content to the JSON file, replacing the keys and passwords with your actual values:

```json
{
  "dev": {
    "key": "your-dev-encryption-key",
    "password": "your-dev-password"
  },
  "qa": {
    "key": "your-qa-encryption-key",
    "password": "your-qa-password"
  },
  "prod": {
    "key": "your-prod-encryption-key",
    "password": "your-prod-password"
  },
  "pre-prod": {
    "key": "your-pre-prod-encryption-key",
    "password": "your-pre-prod-password"
  },
  "demo": {
    "key": "your-demo-encryption-key",
    "password": "your-demo-password"
  }
}

```

### 3. **(Optional) Update the password.enc Files**

If you need to update the password.enc files for any environment (e.g., after changing the encryption key or password), you can do so using the following command:

```shell
echo -n "your-new-password" | openssl enc -aes-256-cbc -a -salt -pass pass:your-new-encryption-key -out envs/<environment>/password.enc

```

Replace <environment> with the appropriate environment name (dev, prod, etc.), and use the new encryption key and password that match the updated values in your trade-feed-etl-health-checker.json file.


### 4. **Run the Playbooks Using npm**

With your environment set up and the necessary tools installed, you can now run the provided Ansible playbooks using npm. Here are some common commands you might use:

Set Up the PostgreSQL Database in Dev:

```shell
npm run trade-feed-dl-db-setup:dev-us-east-1
```

Generate Test Data in Dev:

```shell
npm run trade-feed-test-data-generate:dev-us-east-1

```

```shell
npm run trade-feed-aws-services-setup:dev-us-east-1
```

Terminate Infrastructure in Dev:

```shell
npm run trade-feed-dl-db-terminate:dev-us-east-1
npm run trade-feed-aws-services-terminate:dev-us-east-1
```

### 5. **Contribute to the Project**

If you wish to contribute, please fork the repository, create a new branch, and submit a pull request. Ensure that your contributions adhere to the existing code style and pass all tests.

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



