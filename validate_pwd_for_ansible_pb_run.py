import hashlib
import sys
import yaml
from cryptography.fernet import Fernet
import os

def decrypt_password_file(encrypted_password_file, key):
    with open(encrypted_password_file, 'rb') as file:
        encrypted_data = file.read()
    
    fernet = Fernet(key)
    decrypted_data = fernet.decrypt(encrypted_data).decode()
    return decrypted_data.strip()

def validate_password(input_password, decrypted_password):
    hashed_input_password = hashlib.sha256(input_password.encode()).hexdigest()
    return hashed_input_password == decrypted_password

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python validate_pwd_for_ansible_pb_run.py <password> <encrypted_password_file> <key>")
        sys.exit(1)
    
    password = sys.argv[1]
    encrypted_password_file = sys.argv[2]
    key = sys.argv[3]
    
    try:
        decrypted_password = decrypt_password_file(encrypted_password_file, key)
        if validate_password(password, decrypted_password):
            # Load AWS profile from environment file
            with open(f'envs/{os.environ["ENVIRONMENT"]}.yml', 'r') as stream:
                config = yaml.safe_load(stream)
                aws_profile = config.get('aws_profile')
                os.environ['AWS_PROFILE'] = aws_profile

            sys.exit(0)  # Password is correct
        else:
            print("Incorrect password.")
            sys.exit(1)  # Password is incorrect
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)
