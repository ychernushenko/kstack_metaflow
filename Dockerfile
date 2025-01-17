# Use a base Python image
FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git

# Install Git LFS
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && apt-get install -y git-lfs && \
    git lfs install

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Add Poetry to PATH
ENV PATH="/root/.local/bin:$PATH"

# Configure Poetry to create virtual environments in the project directory
RUN poetry config virtualenvs.in-project true

# Set up a working directory
WORKDIR /app

# Copy project files
COPY . /app/

# Recreate and install project dependencies
RUN poetry env use python && poetry install --no-root

# Set environment variables to activate the virtual environment automatically
ENV VIRTUAL_ENV="/app/.venv"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Set metaflow user
ENV METAFLOW_USER=ychernushenko

# Setup Metaflow
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

# Set environment variables for AWS and Metaflow
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
ENV METAFLOW_DEFAULT_DATASTORE=s3
ENV METAFLOW_DATASTORE_SYSROOT_S3="s3://metaflowpersonal-metaflows3bucket-qjhvdp1sgdsv/datastore"
ENV METAFLOW_DATATOOLS_SYSROOT_S3="s3://metaflowpersonal-metaflows3bucket-qjhvdp1sgdsv/datastools"
ENV METAFLOW_ECS_S3_ACCESS_IAM_ROLE="arn:aws:iam::742491319596:role/MetaflowPersonal-BatchS3TaskRole-XMwedzusMCMY"
ENV METAFLOW_BATCH_JOB_QUEUE="arn:aws:batch:eu-central-1:742491319596:job-queue/job-queue-MetaflowPersonal"

# Log in to Hugging Face CLI during build
ARG HF_TOKEN
RUN poetry run huggingface-cli login --token "$HF_TOKEN" --add-to-git-credential

# Default command
CMD ["bash"]
