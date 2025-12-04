#!/bin/sh
# Health check script for n8n
# This script checks if n8n is running and responding to requests
# Supports both wget and curl for maximum compatibility

# Set defaults
HOST="${N8N_HOST:-localhost}"
PORT="${N8N_PORT:-5678}"
PROTOCOL="${N8N_PROTOCOL:-http}"
HEALTHZ_URL="${PROTOCOL}://${HOST}:${PORT}/healthz"

# Try curl first (more common in Alpine images)
if command -v curl >/dev/null 2>&1; then
    if curl -f -s "${HEALTHZ_URL}" >/dev/null 2>&1; then
        echo "Health check passed - n8n is running (via curl)"
        exit 0
    else
        echo "Health check failed - n8n is not responding correctly (via curl)"
        exit 1
    fi
# Fallback to wget if curl is not available
elif command -v wget >/dev/null 2>&1; then
    response=$(wget --spider -q -S "${HEALTHZ_URL}" 2>&1 | grep "HTTP/" | awk '{print $2}')
    if [ "$response" = "200" ] || [ "$response" = "304" ]; then
        echo "Health check passed - n8n is running (via wget)"
        exit 0
    else
        echo "Health check failed - n8n is not responding correctly (Status: ${response})"
        exit 1
    fi
else
    echo "Health check failed - neither curl nor wget available"
    exit 1
fi
