FROM mcr.microsoft.com/devcontainers/base:bullseye

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    nodejs \
    npm \
    python3-pip \
    python3-venv \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

