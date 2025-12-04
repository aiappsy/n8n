#!/bin/bash
# Coolify Quickstart Script for n8n
# This script helps you set up the necessary environment variables for deploying n8n on Coolify

set -e

echo "============================================"
echo "n8n Coolify Deployment - Quick Start Setup"
echo "============================================"
echo ""

# Check if .env already exists
if [ -f ".env" ]; then
    echo "⚠️  Warning: .env file already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting without changes."
        exit 0
    fi
    mv .env .env.backup.$(date +%s)
    echo "✓ Backed up existing .env file"
fi

# Copy .env.example to .env
if [ ! -f ".env.example" ]; then
    echo "❌ Error: .env.example not found!"
    exit 1
fi

cp .env.example .env
echo "✓ Created .env file from .env.example"
echo ""

# Generate secure passwords and keys
echo "Generating secure passwords and keys..."
echo ""

# Generate database password
DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
echo "✓ Generated database password"

# Generate encryption key
ENCRYPTION_KEY=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
echo "✓ Generated encryption key"

# Ask for domain
echo ""
echo "Enter your domain for n8n (e.g., n8n.yourdomain.com):"
read -p "Domain: " DOMAIN

if [ -z "$DOMAIN" ]; then
    DOMAIN="localhost"
    WEBHOOK_URL="http://localhost:5678/"
    N8N_PROTOCOL="http"
    echo "⚠️  No domain provided, using localhost"
else
    WEBHOOK_URL="https://${DOMAIN}/"
    N8N_PROTOCOL="https"
fi

echo ""
echo "Do you want to enable basic authentication? (recommended for security)"
read -p "Enable basic auth? (y/N): " -n 1 -r
echo

BASIC_AUTH_ENABLED="false"
BASIC_AUTH_USER=""
BASIC_AUTH_PASS=""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    BASIC_AUTH_ENABLED="true"
    read -p "Basic auth username: " BASIC_AUTH_USER
    read -sp "Basic auth password: " BASIC_AUTH_PASS
    echo ""
fi

echo ""
echo "Updating .env file with generated values..."

# Update .env file
sed -i.bak "s|POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=${DB_PASSWORD}|" .env
sed -i.bak "s|POSTGRES_NON_ROOT_PASSWORD=.*|POSTGRES_NON_ROOT_PASSWORD=${DB_PASSWORD}|" .env
sed -i.bak "s|N8N_ENCRYPTION_KEY=.*|N8N_ENCRYPTION_KEY=${ENCRYPTION_KEY}|" .env
sed -i.bak "s|WEBHOOK_URL=.*|WEBHOOK_URL=${WEBHOOK_URL}|" .env
sed -i.bak "s|N8N_PROTOCOL=.*|N8N_PROTOCOL=${N8N_PROTOCOL}|" .env
sed -i.bak "s|N8N_BASIC_AUTH_ACTIVE=.*|N8N_BASIC_AUTH_ACTIVE=${BASIC_AUTH_ENABLED}|" .env

if [ ! -z "$BASIC_AUTH_USER" ]; then
    sed -i.bak "s|N8N_BASIC_AUTH_USER=.*|N8N_BASIC_AUTH_USER=${BASIC_AUTH_USER}|" .env
    sed -i.bak "s|N8N_BASIC_AUTH_PASSWORD=.*|N8N_BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASS}|" .env
fi

# Clean up backup files
rm -f .env.bak

echo ""
echo "✓ Environment variables configured successfully!"
echo ""
echo "============================================"
echo "Configuration Summary"
echo "============================================"
echo "Domain: ${DOMAIN}"
echo "Webhook URL: ${WEBHOOK_URL}"
echo "Protocol: ${N8N_PROTOCOL}"
echo "Basic Auth: ${BASIC_AUTH_ENABLED}"
if [ ! -z "$BASIC_AUTH_USER" ]; then
    echo "Basic Auth User: ${BASIC_AUTH_USER}"
fi
echo ""
echo "✓ Database password: [GENERATED]"
echo "✓ Encryption key: [GENERATED]"
echo ""
echo "============================================"
echo "Next Steps for Coolify Deployment"
echo "============================================"
echo ""
echo "1. Push this repository to your Git repository"
echo "2. In Coolify, create a new resource:"
echo "   - Select 'Docker Compose'"
echo "   - Point to your repository"
echo "   - Select 'docker-compose.yml' as the compose file"
echo ""
echo "3. In Coolify environment variables, copy these values:"
echo "   POSTGRES_PASSWORD=${DB_PASSWORD}"
echo "   N8N_ENCRYPTION_KEY=${ENCRYPTION_KEY}"
echo "   WEBHOOK_URL=${WEBHOOK_URL}"
echo "   N8N_PROTOCOL=${N8N_PROTOCOL}"
if [ ! -z "$BASIC_AUTH_USER" ]; then
    echo "   N8N_BASIC_AUTH_ACTIVE=${BASIC_AUTH_ENABLED}"
    echo "   N8N_BASIC_AUTH_USER=${BASIC_AUTH_USER}"
    echo "   N8N_BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASS}"
fi
echo ""
echo "4. Set up domain in Coolify and enable SSL"
echo "5. Deploy!"
echo ""
echo "For detailed instructions, see README-COOLIFY.md"
echo ""
echo "⚠️  IMPORTANT: Keep your .env file secure and never commit it to Git!"
echo "============================================"
