# Microsoft提供のC++用イメージを使用
FROM mcr.microsoft.com/devcontainers/cpp:1-debian-12

# 必要なパッケージのインストール (Node.js, Python3, pip)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    nodejs \
    npm \
    python3-pip \
    python3-venv \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# npm自体のアップデート（オプション）
RUN npm install -g n && n stable
