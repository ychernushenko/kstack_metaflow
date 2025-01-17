import json
import os

import boto3


def get_secret(secret_name):
    client = boto3.client("secretsmanager", region_name="eu-central-1")
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response["SecretString"])
    return secret


def set_environment_variables(var, secret):
    os.environ[var] = secret
