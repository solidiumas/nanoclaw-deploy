#!/bin/bash

set -e

echo "🚀 Starting NanoClaw installation..."

REPO_URL="https://github.com/solidiumas/nanoclaw-deploy.git"
DEPLOY_DIR="/root/nanoclaw-deploy"
NANOCLAW_DIR="/root/nanoclaw"

# --- UPDATE ---
echo "📦 Updating system..."
apt update -y

# --- FIX DOCKER CONFLICT (CRITICAL) ---
echo "🧹 Removing containerd conflicts..."
apt-get remove -y containerd containerd.io docker docker-engine docker.io || true
apt-get purge -y containerd containerd.io || true
apt-get autoremove -y

# --- CLEAN CACHE ---
apt-get clean

# --- INSTALL DOCKER (SAFE) ---
echo "🐳 Installing Docker..."
apt-get install -y docker.io docker-compose git curl

# --- START DOCKER ---
systemctl enable docker
systemctl start docker

# --- VERIFY ---
docker --version || (echo "❌ Docker install failed" && exit 1)

# --- PERMISSIONS ---
chmod 666 /var/run/docker.sock || true

# --- CLONE DEPLOY REPO ---
echo "📥 Cloning deploy repo..."
if [ ! -d "$DEPLOY_DIR" ]; then
  git clone $REPO_URL $DEPLOY_DIR
else
  cd $DEPLOY_DIR && git pull
fi

cd $DEPLOY_DIR

# --- ENV ---
if [ ! -f ".env" ]; then
  cp .env.example .env
  echo "⚠️ SET YOUR API KEY:"
  echo "nano $DEPLOY_DIR/.env"
  sleep 10
fi

# --- CLONE NANOCLAW ---
echo "📥 Cloning NanoClaw..."
if [ ! -d "$NANOCLAW_DIR" ]; then
  git clone https://github.com/qwibitai/nanoclaw.git $NANOCLAW_DIR
fi

# --- BUILD AGENT ---
echo "🏗️ Building agent container..."
cd $NANOCLAW_DIR/container
docker build -t nanoclaw-agent:latest .

# --- START ---
echo "🚀 Starting NanoClaw..."
cd $DEPLOY_DIR
docker-compose up -d --build

# --- STATUS ---
sleep 5
docker ps

echo ""
echo "✅ DONE"
echo "👉 http://$(curl -s ifconfig.me):3000"
