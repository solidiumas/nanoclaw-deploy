#!/bin/bash
set -e # Stopper skriptet ved feil

echo "🚀 Installerer NanoClaw via GitHub Container Registry..."

# 1. Installer Docker hvis det mangler
if ! [ -x "$(command -v docker)" ]; then
    echo "📦 Installerer Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
fi

# 2. Opprett mappe for installasjon
mkdir -p /opt/nanoclaw
cd /opt/nanoclaw

# 3. Last ned kun docker-compose.yml
echo "📂 Henter konfigurasjon..."
curl -sSL https://raw.githubusercontent.com/solidiumas/nanoclaw-deploy/main/docker-compose.yml -o docker-compose.yml

# 4. Pull og start (Siden imaget er offentlig trenger man ikke login)
echo "🐳 Starter containere..."
docker compose pull
docker compose up -d

echo "✨ NanoClaw er nå installert og kjører på port 80!"
