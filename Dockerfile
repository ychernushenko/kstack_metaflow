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

# Log in to Hugging Face CLI during build
ARG HF_TOKEN
RUN poetry run huggingface-cli login --token "$HF_TOKEN" --add-to-git-credential

# Default command
CMD ["bash"]
