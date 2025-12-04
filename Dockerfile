# Dockerfile for n8n deployment on Coolify
# This Dockerfile uses the official n8n Docker image as a base
# For production use with Coolify

ARG N8N_VERSION=latest

# Use the official n8n image from Docker Hub
FROM docker.n8n.io/n8nio/n8n:${N8N_VERSION}

# Set maintainer label
LABEL maintainer="n8n"
LABEL description="n8n - Workflow Automation Tool for Coolify"
LABEL org.opencontainers.image.source="https://github.com/aiappsy/n8n"

# The base image already includes:
# - n8n application
# - All dependencies
# - Proper entrypoint
# - Health checks
# - User configuration

# Set working directory
WORKDIR /home/node

# Expose port
EXPOSE 5678

# Health check (inherits from base image but explicitly defined for clarity)
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --spider -q http://localhost:5678/healthz || exit 1

# The ENTRYPOINT is inherited from the base image
# which is: ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
