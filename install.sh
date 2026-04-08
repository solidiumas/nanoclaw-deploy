#!/bin/bash

set -e

echo "🚀 Starting NanoClaw installation..."

# --- VARIABLES ---
REPO_URL="https://github.com/solidiumas/nanoclaw-deploy.git"
NANOCLAW_DIR="/root/nanoclaw"
DEPLOY_DIR="/root/nanoclaw-deploy"

# --- UPDATE SYSTEM ---
echo "📦 Updating system..."
apt update -y && apt upgrade -y

# --- INSTALL DEPENDENCIES ---
echo "🔧 Installing dependencies..."
apt install -y docker.io docker-compose git curl

# --- START DOCKER ---
echo "🐳 Starting Docker..."
systemctl enable docker
systemctl start docker

# --- FIX DOCKER PERMISSIONS ---
echo "🔐 Setting Docker permissions..."
chmod 666 /var/run/docker.sock || true

# --- CLONE DEPLOY REPO ---
echo "📥 Cloning deploy repo..."
if [ ! -d "$DEPLOY_DIR" ]; then
  git clone $REPO_URL $DEPLOY_DIR
else
  echo "Repo already exists, pulling latest..."
  cd $DEPLOY_DIR
  git pull
fi

cd $DEPLOY_DIR

# --- SETUP ENV ---
if [ ! -f ".env" ]; then
  echo "⚙️ Creating .env file..."
  cp .env.example .env
  echo "⚠️ IMPORTANT: Edit your API key now!"
  echo "Run: nano $DEPLOY_DIR/.env"
  sleep 10
else
  echo ".env already exists"
fi

# --- CLONE NANOCLAW CORE ---
echo "📥 Cloning NanoClaw core..."
if [ ! -d "$NANOCLAW_DIR" ]; then
  git clone https://github.com/qwibitai/nanoclaw.git $NANOCLAW_DIR
else
  echo "NanoClaw already exists, skipping clone"
fi

# --- BUILD AGENT CONTAINER ---
echo "🏗️ Building agent container..."
cd $NANOCLAW_DIR/container
docker build -t nanoclaw-agent:latest .

# --- START SERVICES ---
echo "🚀 Starting NanoClaw services..."
cd $DEPLOY_DIR
docker-compose up -d --build

# --- WAIT & CHECK ---
sleep 5

echo "🔍 Checking container status..."
docker ps | grep nanoclaw || echo "⚠️ NanoClaw container not detected"

# --- DONE ---
echo ""
echo "✅ INSTALLATION COMPLETE"
echo "👉 Open in browser: http://$(curl -s ifconfig.me):3000"
echo ""
echo "📌 If something failed:"
echo "docker logs nanoclaw"
echo ""
