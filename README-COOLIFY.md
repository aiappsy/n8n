# n8n Deployment on Coolify

This guide provides step-by-step instructions for deploying n8n on Coolify, a self-hosted PaaS alternative to Heroku and Netlify.

## 📋 Prerequisites

- A running Coolify instance
- A domain name (optional but recommended for webhooks)
- Basic understanding of Docker and environment variables

## 🚀 Quick Start

### 1. Prepare Your Repository

This repository is already configured for Coolify deployment with:
- ✅ `Dockerfile` - Multi-stage production build
- ✅ `docker-compose.yml` - Complete orchestration
- ✅ `.env.example` - All environment variables documented
- ✅ Health checks and proper networking

### 2. Fork or Clone This Repository

If you're deploying from this repository:
```bash
git clone https://github.com/aiappsy/n8n.git
cd n8n
```

### 3. Deploy on Coolify

#### Option A: Using Docker Compose (Recommended)

1. **Create a new Resource in Coolify:**
   - Go to your Coolify dashboard
   - Click "New Resource"
   - Select "Docker Compose"
   - Choose "Public Repository" or connect your Git repository

2. **Repository Configuration:**
   - Repository URL: `https://github.com/aiappsy/n8n.git`
   - Branch: `main` (or your preferred branch)
   - Docker Compose Location: `/docker-compose.yml`

3. **Environment Variables:**
   
   Configure the following **REQUIRED** variables in Coolify:
   
   ```bash
   # Database Password (REQUIRED)
   POSTGRES_PASSWORD=your_secure_database_password
   
   # Encryption Key (REQUIRED) - Generate with: openssl rand -base64 32
   N8N_ENCRYPTION_KEY=your_32_character_encryption_key
   
   # Webhook URL (REQUIRED for proper operation)
   WEBHOOK_URL=https://your-n8n-domain.coolify.io/
   ```

   **Optional but Recommended:**
   ```bash
   # Use HTTPS if Coolify SSL is enabled
   N8N_PROTOCOL=https
   
   # Basic Authentication
   N8N_BASIC_AUTH_ACTIVE=true
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=your_secure_password
   
   # Timezone
   GENERIC_TIMEZONE=America/New_York
   TZ=America/New_York
   ```

4. **Domain Configuration:**
   - In Coolify, add a domain to your n8n service
   - Example: `n8n.yourdomain.com`
   - Enable SSL/TLS (Let's Encrypt)
   - Update `WEBHOOK_URL` environment variable with your domain

5. **Deploy:**
   - Click "Deploy" in Coolify
   - Wait for the build and deployment to complete
   - Check the logs for any errors

#### Option B: Using Dockerfile Only

If you prefer to deploy just the n8n service without the bundled PostgreSQL:

1. Create a new Resource in Coolify as "Dockerfile"
2. Point to this repository
3. Dockerfile location: `/Dockerfile`
4. Configure environment variables (you'll need to provide your own database)
5. Deploy

### 4. Post-Deployment Setup

1. **Access n8n:**
   - Navigate to your configured domain (e.g., `https://n8n.yourdomain.com`)
   - You should see the n8n setup wizard

2. **Initial Setup:**
   - Create your admin account
   - Configure your email (if using email features)
   - Set up any additional authentication methods

3. **Test Webhooks:**
   - Create a test workflow with a webhook trigger
   - Ensure the webhook URL uses your actual domain
   - Test the webhook to confirm it's working

## 🔧 Configuration Details

### Environment Variables

All environment variables are documented in `.env.example`. Key variables include:

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `POSTGRES_PASSWORD` | ✅ Yes | Database password | `securePass123!` |
| `N8N_ENCRYPTION_KEY` | ✅ Yes | Credential encryption key | (32 char random string) |
| `WEBHOOK_URL` | ✅ Yes | Public webhook URL | `https://n8n.domain.com/` |
| `N8N_PROTOCOL` | Recommended | Protocol for webhooks | `https` |
| `N8N_BASIC_AUTH_ACTIVE` | No | Enable basic auth | `true` |
| `GENERIC_TIMEZONE` | No | Application timezone | `UTC` |
| `N8N_LOG_LEVEL` | No | Logging verbosity | `info` |

### Volume Persistence

The following data is persisted in Docker volumes:
- **PostgreSQL data** (`postgres_data`): All workflow and credential data
- **n8n data** (`n8n_data`): User data and configurations
- **n8n files** (`n8n_files`): Uploaded files and assets

**Important:** Ensure Coolify is configured to back up these volumes regularly.

### Health Checks

Both services include health checks:
- **PostgreSQL**: Checks database connectivity every 10s
- **n8n**: Checks HTTP endpoint `/healthz` every 30s

### Networking

Services communicate over a dedicated Docker network (`n8n-network`) for security and isolation.

## 📊 Scaling Considerations

### Queue Mode with Redis (Optional)

For high-volume workflows, enable queue mode:

1. **Uncomment Redis section in `docker-compose.yml`**

2. **Add Redis environment variables:**
   ```bash
   EXECUTIONS_MODE=queue
   QUEUE_BULL_REDIS_HOST=redis
   QUEUE_BULL_REDIS_PORT=6379
   QUEUE_BULL_REDIS_DB=0
   ```

3. **Redeploy** the stack

### Horizontal Scaling

With queue mode enabled, you can scale n8n workers:
```bash
docker-compose up -d --scale n8n=3
```

## 🔒 Security Best Practices

1. **Always use HTTPS** in production (enable SSL in Coolify)
2. **Use strong passwords** for database and basic auth
3. **Rotate encryption keys** periodically (requires data migration)
4. **Enable basic authentication** for additional security layer
5. **Keep n8n updated** to the latest stable version
6. **Restrict network access** using Coolify's firewall features
7. **Regular backups** of PostgreSQL data volume
8. **Monitor logs** for suspicious activity

## 🐛 Troubleshooting

### n8n won't start
- Check Coolify logs for build errors
- Verify all required environment variables are set
- Ensure PostgreSQL is healthy before n8n starts

### Webhooks not working
- Verify `WEBHOOK_URL` matches your actual domain
- Check `N8N_PROTOCOL` is set to `https` if using SSL
- Ensure Coolify's proxy is routing traffic correctly
- Test with a simple webhook workflow

### Database connection errors
- Verify `POSTGRES_PASSWORD` matches in both services
- Check PostgreSQL logs in Coolify
- Ensure database is marked as healthy

### Permission issues
- n8n runs as the `node` user (non-root)
- Ensure volume permissions are correct
- Check Coolify volume mount settings

### Build failures
- Ensure sufficient disk space
- Check Coolify server resources (CPU/RAM)
- Review build logs for specific errors
- Try rebuilding without cache

## 📚 Additional Resources

- [n8n Official Documentation](https://docs.n8n.io/)
- [n8n Self-Hosting Guide](https://docs.n8n.io/hosting/)
- [Coolify Documentation](https://coolify.io/docs)
- [Docker Compose Reference](https://docs.docker.com/compose/)

## 🆘 Support

- **n8n Community**: [community.n8n.io](https://community.n8n.io)
- **Coolify Community**: [Discord](https://coolify.io/discord)
- **Issues**: Report issues on the respective GitHub repositories

## 📝 License

n8n is distributed under the [Sustainable Use License](LICENSE.md) and [n8n Enterprise License](LICENSE_EE.md).

## 🎯 Quick Reference Commands

### Generate Encryption Key
```bash
openssl rand -base64 32
```

### View n8n Logs (via Coolify)
Navigate to your service in Coolify dashboard → Logs

### Backup Database
```bash
docker exec -t <postgres-container-id> pg_dumpall -c -U n8n > dump_$(date +%Y-%m-%d_%H_%M_%S).sql
```

### Restore Database
```bash
cat your_dump.sql | docker exec -i <postgres-container-id> psql -U n8n
```

### Update n8n Version
1. Update `N8N_VERSION` environment variable in Coolify
2. Redeploy the service
3. Monitor logs for migration messages

---

**Ready to automate?** Deploy n8n on Coolify and start building powerful workflows! 🚀
