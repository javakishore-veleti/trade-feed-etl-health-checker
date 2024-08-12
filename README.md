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
touch ~/trade-feed-etl-health-checker_us-east-1_dev-us-east-1.json
touch ~/trade-feed-etl-health-checker_eu-west-1_qa-eu-west-1.json
touch ~/trade-feed-etl-health-checker_ap-south-1_prod-ap-south-1.json
```

```json
{
  "dev": {
    "ses_email": "youremail@email.com",
  "key": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "password": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "aws_access_key_id": "AKIA_CHANGEME",
  "aws_secret_access_key": "CDYE_CHANGEME",
  "aws_region": "us-east-1",
  "aws_profile": "trade-feed-etl-dev-profile",
  "db_instance_identifier": "dev-trade-feed-db",
  "db_name": "trade_feed_db",
  "db_user": "trade_feed_db_user",
  "db_password": "trade_feed_db_password_1!",
  "db_instance_class": "db.t3.medium",
  "db_engine": "postgres",
  "db_allocated_storage": 20,
  "db_subnet_group_name": "default-vpc-CHANGEME",
  "vpc_security_group_ids": ["sg-CHANGEME"],
  "master_username": "trade_feed_db_user",
  "master_user_password": "trade_feed_db_master_user_password",
  "allocated_storage": 20,
  "aws_debug": true,
  "debug_botocore_endpoint_logs": true
  },
  "qa": {
    "ses_email": "youremail@email.com",
  "key": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "password": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "aws_access_key_id": "AKIA_CHANGEME",
  "aws_secret_access_key": "CDYE_CHANGEME",
  "aws_region": "us-east-1",
  "aws_profile": "trade-feed-etl-dev-profile",
  "db_instance_identifier": "dev-trade-feed-db",
  "db_name": "trade_feed_db",
  "db_user": "trade_feed_db_user",
  "db_password": "trade_feed_db_password_1!",
  "db_instance_class": "db.t3.medium",
  "db_engine": "postgres",
  "db_allocated_storage": 20,
  "db_subnet_group_name": "default-vpc-CHANGEME",
  "vpc_security_group_ids": ["sg-CHANGEME"],
  "master_username": "trade_feed_db_user",
  "master_user_password": "trade_feed_db_master_user_password",
  "allocated_storage": 20,
  "aws_debug": true,
  "debug_botocore_endpoint_logs": true
  },
  "prod": {
    "ses_email": "youremail@email.com",
  "key": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "password": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "aws_access_key_id": "AKIA_CHANGEME",
  "aws_secret_access_key": "CDYE_CHANGEME",
  "aws_region": "us-east-1",
  "aws_profile": "trade-feed-etl-dev-profile",
  "db_instance_identifier": "dev-trade-feed-db",
  "db_name": "trade_feed_db",
  "db_user": "trade_feed_db_user",
  "db_password": "trade_feed_db_password_1!",
  "db_instance_class": "db.t3.medium",
  "db_engine": "postgres",
  "db_allocated_storage": 20,
  "db_subnet_group_name": "default-vpc-CHANGEME",
  "vpc_security_group_ids": ["sg-CHANGEME"],
  "master_username": "trade_feed_db_user",
  "master_user_password": "trade_feed_db_master_user_password",
  "allocated_storage": 20,
  "aws_debug": true,
  "debug_botocore_endpoint_logs": true
  },
  "pre-prod": {
    "ses_email": "youremail@email.com",
  "key": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "password": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "aws_access_key_id": "AKIA_CHANGEME",
  "aws_secret_access_key": "CDYE_CHANGEME",
  "aws_region": "us-east-1",
  "aws_profile": "trade-feed-etl-dev-profile",
  "db_instance_identifier": "dev-trade-feed-db",
  "db_name": "trade_feed_db",
  "db_user": "trade_feed_db_user",
  "db_password": "trade_feed_db_password_1!",
  "db_instance_class": "db.t3.medium",
  "db_engine": "postgres",
  "db_allocated_storage": 20,
  "db_subnet_group_name": "default-vpc-CHANGEME",
  "vpc_security_group_ids": ["sg-CHANGEME"],
  "master_username": "trade_feed_db_user",
  "master_user_password": "trade_feed_db_master_user_password",
  "allocated_storage": 20,
  "aws_debug": true,
  "debug_botocore_endpoint_logs": true
  },
  "demo": {
    "ses_email": "youremail@email.com",
  "key": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "password": "U2FsdGVkX18Bp95/s8Wv/EuKpWbsO55S4bZNxssIWuHcmtJm7OH3Tfu3iiKe39zx",
  "aws_access_key_id": "AKIA_CHANGEME",
  "aws_secret_access_key": "CDYE_CHANGEME",
  "aws_region": "us-east-1",
  "aws_profile": "trade-feed-etl-dev-profile",
  "db_instance_identifier": "dev-trade-feed-db",
  "db_name": "trade_feed_db",
  "db_user": "trade_feed_db_user",
  "db_password": "trade_feed_db_password_1!",
  "db_instance_class": "db.t3.medium",
  "db_engine": "postgres",
  "db_allocated_storage": 20,
  "db_subnet_group_name": "default-vpc-CHANGEME",
  "vpc_security_group_ids": ["sg-CHANGEME"],
  "master_username": "trade_feed_db_user",
  "master_user_password": "trade_feed_db_master_user_password",
  "allocated_storage": 20,
  "aws_debug": true,
  "debug_botocore_endpoint_logs": true
  }
}
```

### 3. **(Optional) Update the password.enc Files**
If you need to update the password.enc files for any environment (e.g., after changing the encryption key or password), you can do so using the following command:

```shell
echo -n "your-new-password" | openssl enc -aes-256-cbc -a -salt -pass pass:your-new-encryption-key -out envs/<environment>/password.enc
```

### 4. **Run the Playbooks Using npm**

With your environment set up and the necessary tools installed, you can now run the provided Ansible playbooks using npm. Here are some common commands you might use:

## Setup Commands for One Environment (say DEV)

Here’s the list of commands to be executed for the DEV environment, in the order they should be run:

```shell
# Set Up PostgreSQL Database in Dev Environment
npm run trade-feed-dl-db-setup:dev-us-east-1

# Generate Test Data in Dev Environment
npm run trade-feed-test-data-generate:dev-us-east-1

# Make RDS PostgreSQL Public in Dev Environment
npm run make-rds-public:dev-us-east-1

# Create DB Scripts Execution Log Table in Dev Environment
npm run create-db-scripts-log-table:dev-us-east-1

# List Tables in PostgreSQL Database for Dev Environment
npm run trade-feed-list-tables:dev-us-east-1

# Execute SQL Scripts in Dev Environment
npm run execute-sql-scripts:dev-us-east-1

# List Tables in PostgreSQL Database for Dev Environment
npm run trade-feed-list-tables:dev-us-east-1

# Setup AWS Event Bridge Lambda AWS SES
npm run setup-postgres-eventbridge-lambda-ses:dev-us-east-1

# Terminate PostgreSQL Database in Dev Environment
npm run trade-feed-dl-db-terminate:dev-us-east-1

# Terminate AWS Services in Dev Environment
npm run trade-feed-aws-services-terminate:dev-us-east-1

```

## Setup Commands for One Environment (say QA)

Here’s the list of commands to be executed for the QA environment, in the order they should be run:

```shell
# Set Up PostgreSQL Database in QA Environment
npm run trade-feed-dl-db-setup:qa-eu-west-1

# Generate Test Data in QA Environment
npm run trade-feed-test-data-generate:qa-eu-west-1

# Set Up AWS Services in QA Environment
npm run trade-feed-aws-services-setup:qa-eu-west-1

# Make RDS PostgreSQL Public in QA Environment
npm run make-rds-public:qa-us-west-2

# List Tables in PostgreSQL Database for QA Environment
npm run trade-feed-list-tables:qa-eu-west-1

# Terminate PostgreSQL Database in QA Environment
npm run trade-feed-dl-db-terminate:qa-eu-west-1

# Terminate AWS Services in QA Environment
npm run trade-feed-aws-services-terminate:qa-eu-west-1

```

## Setup and Infrastructure Commands

### Set Up PostgreSQL Database

- **Dev Environment (us-east-1):**
```shell
npm run trade-feed-dl-db-setup:dev-us-east-1
```

- **QA Environment (eu-west-1):**
```shell
npm run trade-feed-dl-db-setup:qa-eu-west-1
```

- **Prod Environment (ap-south-1):**
```shell
npm run trade-feed-dl-db-setup:prod-ap-south-1
```

### Generate Test Data

- **Dev Environment (us-east-1):**
```shell
npm run trade-feed-test-data-generate:dev-us-east-1
```

- **QA Environment (eu-west-1):**
```shell
npm run trade-feed-test-data-generate:qa-eu-west-1
```

- **Prod Environment (ap-south-1):**
```shell
npm run trade-feed-test-data-generate:prod-ap-south-1
```

### Set Up AWS Services

- **Dev Environment (us-east-1):**
```shell
npm run trade-feed-aws-services-setup:dev-us-east-1
```

- **QA Environment (eu-west-1):**
```shell
npm run trade-feed-aws-services-setup:qa-eu-west-1
```

- **Prod Environment (ap-south-1):**
```shell
npm run trade-feed-aws-services-setup:prod-ap-south-1
```

### Termination Commands

#### Terminate PostgreSQL Database

- **Dev Environment (us-east-1):**
```shell
npm run trade-feed-aws-services-setup:dev-us-east-1
```

- **QA Environment (eu-west-1):**
```shell
npm run trade-feed-dl-db-terminate:qa-eu-west-1
```

- **Prod Environment (ap-south-1):**
```shell
npm run trade-feed-dl-db-terminate:prod-ap-south-1
```

#### Terminate AWS Services

- **Dev Environment (us-east-1):**
```shell
npm run trade-feed-aws-services-terminate:dev-us-east-1
```

- **QA Environment (eu-west-1):**
```shell
npm run trade-feed-aws-services-terminate:qa-eu-west-1
```

- **Prod Environment (ap-south-1):**
```shell
npm run trade-feed-aws-services-terminate:prod-ap-south-1
```

### Utility and Database Commands

#### List Tables in PostgreSQL Database

- **Dev Environment (us-east-1):**
```shell
npm run trade-feed-list-tables:dev-us-east-1
```

- **QA Environment (eu-west-1):**
```shell
npm run trade-feed-list-tables:qa-eu-west-1
```

- **Prod Environment (ap-south-1):**
```shell
npm run trade-feed-list-tables:prod-ap-south-1
```

#### Make RDS PostgreSQL Public

- **Dev Environment (us-east-1):**
```shell
npm run make-rds-public:dev-us-east-1
```

- **QA Environment (eu-west-1):**
```shell
npm run make-rds-public:qa-us-west-2
```

- **Prod Environment (ap-south-1):**
```shell
npm run make-rds-public:prod-eu-central-1
```

#### Execute SQL Scripts

- **Dev Environment (us-east-1):**
```shell
npm run execute-sql-scripts:dev
```

- **QA Environment (eu-west-1):**
```shell
npm run execute-sql-scripts:qa
```

- **Prod Environment (ap-south-1):**
```shell
npm run execute-sql-scripts:prod
```

## Prerequisites

- Git Bash or PowerShell: For running shell scripts on Windows, use Git Bash or PowerShell.
- jq: A lightweight JSON processor required for parsing JSON in shell scripts. Install via your package manager (e.g., choco install jq for Windows).
- Ansible: Ensure Ansible is installed on your system for running the playbooks.
- Python 3: Required for running the password validation script.
- AWS CLI: Set up with the necessary profiles, each prefixed with trade-feed-etl for different environments.
- npm: Used to run the scripts defined in package.json.

