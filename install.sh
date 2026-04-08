#!/bin/bash

set -e

echo "🚀 Installing NanoClaw..."

# Update system
apt update -y
apt upgrade -y

# Install dependencies
apt install -y docker.io docker-compose git curl

# Start docker
systemctl start docker
systemctl enable docker

# Fix permissions
usermod -aG docker $USER

# Clone repo (FIXED)
cd /root
git clone https://github.com/solidiumas/nanoclaw-deploy.git
cd nanoclaw-deploy

# Setup env
cp .env.example .env
echo "👉 Edit your .env file:"
echo "nano .env"
sleep 5

# Build agent container manually (CRITICAL STEP)
cd /root
git clone https://github.com/qwibitai/nanoclaw.git || true
cd nanoclaw/container
docker build -t nanoclaw-agent:latest .

# Start services
cd /root/nanoclaw-deploy
docker-compose up -d --build

echo "✅ NanoClaw installed!"
echo "👉 Access: http://YOUR_SERVER_IP:3000"
