#!/bin/bash

# Farger for terminal-output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starter NanoClaw-installasjon...${NC}"

# 1. Sjekk for Docker og installer hvis det mangler
if ! [ -x "$(command -v docker)" ]; then
    echo "📦 Installerer Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
else
    echo "✅ Docker er allerede installert."
fi

# 2. Sjekk for Docker Compose (V2 er inkludert i nyere Docker-installs)
if ! docker compose version > /dev/null 2>&1; then
    echo "📦 Installerer Docker Compose plugin..."
    apt-get update && apt-get install -y docker-compose-plugin
fi

# 3. Opprett mappe og last ned docker-compose.yml
echo "📂 Klargjør filer..."
mkdir -p nanoclaw
cd nanoclaw

# Last ned selve compose-filen fra repoet ditt
curl -sSL https://raw.githubusercontent.com/solidiumas/nanoclaw-deploy/main/docker-compose.yml -o docker-compose.yml

# 4. Start NanoClaw
echo -e "${GREEN}🐳 Starter containere med Docker Compose...${NC}"
docker compose up -d

echo -e "${GREEN}✨ Installasjonen er fullført!${NC}"
echo "Du kan nå få tilgang til NanoClaw på serverens IP-adresse."
