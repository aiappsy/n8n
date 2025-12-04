#!/bin/sh
# Health check script for n8n
# This script checks if n8n is running and responding to requests

# Set defaults
HOST="${N8N_HOST:-localhost}"
PORT="${N8N_PORT:-5678}"
PROTOCOL="${N8N_PROTOCOL:-http}"

# Perform health check
response=$(wget --spider -q -S "${PROTOCOL}://${HOST}:${PORT}/healthz" 2>&1 | grep "HTTP/" | awk '{print $2}')

if [ "$response" = "200" ] || [ "$response" = "304" ]; then
    echo "Health check passed - n8n is running"
    exit 0
else
    echo "Health check failed - n8n is not responding correctly (Status: ${response})"
    exit 1
fi
