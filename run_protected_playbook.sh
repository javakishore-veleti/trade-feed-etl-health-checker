# Define paths and variables
param (
    [string]$Environment,
    [string]$PlaybookCommand
)

$HomeDir = $env:USERPROFILE
$JsonFilePath = "$HomeDir\trade-feed-etl-health-checker.json"

# Load AWS profile from the environment YAML file
$EnvFileContent = Get-Content "envs\$Environment.yml"
$AwsProfile = ($EnvFileContent | Select-String -Pattern "aws_profile").Line.Split(": ")[1].Trim()

# Set the AWS profile for the session
$env:AWS_PROFILE = $AwsProfile

# Load key and password from the JSON file
$JsonContent = Get-Content -Raw -Path $JsonFilePath | ConvertFrom-Json
$Key = $JsonContent.$Environment.key
$Password = $JsonContent.$Environment.password

# Run Python script to validate the password
$PythonScript = "python3 validate_pwd_for_ansible_pb_run.py '$Password' 'envs\$Environment\password.enc' '$Key'"
Invoke-Expression $PythonScript

# Check if password validation was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Password validated successfully. Running Ansible playbook..."
    Invoke-Expression $PlaybookCommand
} else {
    Write-Host "Failed to validate password. Aborting..."
    exit 1
}
