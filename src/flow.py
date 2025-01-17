import json
import os

import boto3
from metaflow import FlowSpec, step


def get_secret(secret_name):
    client = boto3.client("secretsmanager", region_name="eu-central-1")
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response["SecretString"])
    return secret


def set_environment_variables(var, secret):
    os.environ[var] = secret


class CounterFlow(FlowSpec):

    @step
    def start(self):
        secret_name = "METAFLOW_HF_TOKEN"
        secret = get_secret(secret_name)
        set_environment_variables("HF_TOKEN", secret["HF_TOKEN"])

        self.count = 0
        self.next(self.add)

    @step
    def add(self):
        print("The count is", self.count, "before incrementing")
        self.count += 1
        self.next(self.end)

    @step
    def end(self):
        self.count += 1
        print("The final count is", self.count)


if __name__ == "__main__":
    CounterFlow()
