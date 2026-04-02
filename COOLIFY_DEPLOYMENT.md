# n8n Deployment on Coolify

This guide will walk you through deploying n8n on Coolify, a self-hostable Platform-as-a-Service (PaaS) that makes deployment simple and streamlined.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Setup Instructions](#detailed-setup-instructions)
- [Environment Variables Configuration](#environment-variables-configuration)
- [Post-Deployment Steps](#post-deployment-steps)
- [Accessing n8n](#accessing-n8n)
- [Backup and Maintenance](#backup-and-maintenance)
- [Troubleshooting](#troubleshooting)
- [Upgrading n8n](#upgrading-n8n)
- [Security Best Practices](#security-best-practices)

## Prerequisites

Before you begin, ensure you have:

1. **A Coolify instance** running and accessible
   - If you don't have Coolify installed, visit [coolify.io](https://coolify.io) for installation instructions
2. **A domain name** (optional but recommended for production)
   - You can also use Coolify's generated domain or an IP address for testing
3. **Basic understanding** of Docker and environment variables

## Quick Start

For experienced users who want to get started quickly:

1. Create a new project in Coolify
2. Add a new "Docker Compose" resource
3. Copy the contents of `docker-compose.coolify.yml` from this repository
4. Configure environment variables from `.env.coolify.example`
5. Deploy and access n8n at `https://your-domain.com:5678`

For detailed step-by-step instructions, continue reading below.

## Detailed Setup Instructions

### Step 1: Prepare Configuration Files

1. **Copy the environment variables template:**
   ```bash
   cp .env.coolify.example .env
   ```

2. **Generate secure credentials:**
   
   For the encryption key (32-character random string):
   ```bash
   openssl rand -hex 32
   ```
   
   Or using Node.js:
   ```bash
   node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
   ```

3. **Edit the `.env` file** and update the following required variables:
   - `POSTGRES_PASSWORD` - Strong password for the database
   - `N8N_HOST` - Your domain name (e.g., `workflow.yourdomain.com`)
   - `N8N_PROTOCOL` - Set to `https` if using SSL/TLS (recommended)
   - `WEBHOOK_URL` - Full URL where n8n will be accessible (e.g., `https://workflow.yourdomain.com`)
   - `N8N_ENCRYPTION_KEY` - Use the generated encryption key from step 2
   - `N8N_BASIC_AUTH_USER` - Admin username
   - `N8N_BASIC_AUTH_PASSWORD` - Strong admin password

### Step 2: Create a New Project in Coolify

1. Log into your Coolify dashboard
2. Click on **"+ New"** or **"Create New Project"**
3. Enter a project name (e.g., "n8n-automation")
4. Select your server/destination

### Step 3: Add Docker Compose Resource

1. Inside your project, click **"+ New Resource"**
2. Select **"Docker Compose"**
3. Give it a name (e.g., "n8n-production")

### Step 4: Configure Docker Compose

1. In the Docker Compose configuration field, paste the contents of `docker-compose.coolify.yml`
2. The file is pre-configured with:
   - ✅ n8n service (port 5678)
   - ✅ PostgreSQL 16 database
   - ✅ Persistent volumes for data
   - ✅ Health checks
   - ✅ Proper networking

### Step 5: Configure Environment Variables

In Coolify's environment variables section, add all the variables from your `.env` file:

#### Required Variables (Must be configured):

```env
# Database
POSTGRES_USER=n8n
POSTGRES_PASSWORD=your_secure_database_password
POSTGRES_DB=n8n

# n8n Host & URL
N8N_HOST=your-domain.com
N8N_PROTOCOL=https
WEBHOOK_URL=https://your-domain.com

# Security
N8N_ENCRYPTION_KEY=your_generated_encryption_key_32_chars_minimum

# Basic Auth
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_secure_admin_password
```

#### Optional Variables (Recommended):

```env
# Timezone
GENERIC_TIMEZONE=America/New_York
TZ=America/New_York

# Execution Data
EXECUTIONS_DATA_SAVE_ON_ERROR=all
EXECUTIONS_DATA_SAVE_ON_SUCCESS=all
EXECUTIONS_DATA_SAVE_MANUAL_EXECUTIONS=true

# Logging
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=console

# Diagnostics
N8N_DIAGNOSTICS_ENABLED=false
```

### Step 6: Configure Domain and Port

1. **Domain Configuration:**
   - In Coolify, go to your resource's **"Domains"** section
   - Add your domain name
   - Coolify will automatically configure SSL/TLS with Let's Encrypt

2. **Port Configuration:**
   - The docker-compose file exposes port **5678**
   - Coolify will handle the reverse proxy automatically
   - If using Coolify's proxy, the service will be accessible via your domain without specifying the port
   - For direct access, use: `https://your-domain.com:5678`

### Step 7: Configure Volumes

The deployment automatically creates two persistent volumes:

1. **`n8n_data`** - Mounted to `/home/node/.n8n`
   - Stores n8n workflows, credentials, and configuration
   
2. **`postgres_data`** - Mounted to `/var/lib/postgresql/data`
   - Stores the PostgreSQL database

These volumes are managed by Docker and will persist across container restarts and updates.

### Step 8: Deploy

1. Review all configurations
2. Click **"Deploy"** or **"Start"** in Coolify
3. Monitor the deployment logs for any errors
4. Wait for both services to become healthy (usually 1-2 minutes)

The health checks will verify:
- PostgreSQL is accepting connections
- n8n is responding on the `/healthz` endpoint

## Environment Variables Configuration

### Critical Security Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `N8N_ENCRYPTION_KEY` | Encrypts credentials in database. **Never change after initial setup!** | `a1b2c3d4e5f6...` (32+ chars) |
| `POSTGRES_PASSWORD` | Database password | `MyS3cur3P@ssw0rd!` |
| `N8N_BASIC_AUTH_PASSWORD` | n8n admin password | `Adm1nP@ssw0rd!` |

### URL Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| `N8N_HOST` | Domain/hostname | `workflow.example.com` |
| `N8N_PROTOCOL` | HTTP protocol | `https` |
| `WEBHOOK_URL` | Full webhook URL | `https://workflow.example.com` |

### Optional Features

| Variable | Description | Default |
|----------|-------------|---------|
| `GENERIC_TIMEZONE` | Workflow timezone | `UTC` |
| `N8N_LOG_LEVEL` | Logging verbosity | `info` |
| `N8N_DIAGNOSTICS_ENABLED` | Anonymous usage stats | `false` |
| `EXECUTIONS_DATA_SAVE_ON_ERROR` | Save failed executions | `all` |
| `EXECUTIONS_DATA_SAVE_ON_SUCCESS` | Save successful executions | `all` |

## Post-Deployment Steps

### 1. Verify Deployment

Check that both services are running:

```bash
# In Coolify's terminal or SSH to your server
docker ps
```

You should see both `n8n` and `postgres` containers running.

### 2. Check Health Status

Monitor the health checks in Coolify's dashboard or run:

```bash
docker compose -f docker-compose.coolify.yml ps
```

Both services should show as "healthy".

### 3. Test Database Connection

Verify PostgreSQL is accessible:

```bash
docker compose -f docker-compose.coolify.yml exec postgres pg_isready -U n8n
```

Expected output: `postgres:5432 - accepting connections`

### 4. Access n8n

Navigate to your configured URL:
- With Coolify proxy: `https://your-domain.com`
- Direct access: `https://your-domain.com:5678`

### 5. First-Time Login

1. Enter your configured credentials:
   - Username: Value from `N8N_BASIC_AUTH_USER`
   - Password: Value from `N8N_BASIC_AUTH_PASSWORD`

2. Complete the welcome wizard if prompted

3. Start creating your first workflow!

## Accessing n8n

### Via Domain (Recommended)

If you configured a domain in Coolify:
```
https://your-domain.com
```

### Via IP Address (Testing/Development)

If using an IP address:
```
http://your-server-ip:5678
```

### Via Coolify's Generated Domain

Coolify can generate a domain for you automatically. Check your resource's domain settings.

## Backup and Maintenance

### Backup Strategy

**Important:** Regular backups are crucial for production deployments.

#### 1. Database Backup

```bash
# Create a backup
docker compose -f docker-compose.coolify.yml exec postgres pg_dump -U n8n n8n > n8n_backup_$(date +%Y%m%d).sql

# Restore from backup
docker compose -f docker-compose.coolify.yml exec -T postgres psql -U n8n n8n < n8n_backup_20240101.sql
```

#### 2. Volume Backup

```bash
# Backup n8n data volume
docker run --rm \
  -v n8n_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/n8n_data_backup_$(date +%Y%m%d).tar.gz -C /data .

# Backup postgres data volume
docker run --rm \
  -v postgres_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres_data_backup_$(date +%Y%m%d).tar.gz -C /data .
```

#### 3. Automated Backups

Consider setting up automated backups using:
- Coolify's built-in backup features
- Cron jobs on your server
- Cloud storage solutions (S3, B2, etc.)

### Viewing Logs

```bash
# n8n logs
docker compose -f docker-compose.coolify.yml logs -f n8n

# PostgreSQL logs
docker compose -f docker-compose.coolify.yml logs -f postgres

# All logs
docker compose -f docker-compose.coolify.yml logs -f
```

In Coolify, you can also view logs directly in the dashboard under your resource's "Logs" section.

## Troubleshooting

### Service Won't Start

**Symptom:** Containers keep restarting

**Solutions:**

1. **Check logs:**
   ```bash
   docker compose -f docker-compose.coolify.yml logs n8n
   docker compose -f docker-compose.coolify.yml logs postgres
   ```

2. **Verify environment variables:**
   - Ensure all required variables are set
   - Check for typos in variable names
   - Verify no special characters are breaking the configuration

3. **Check health status:**
   ```bash
   docker compose -f docker-compose.coolify.yml ps
   ```

### Cannot Access n8n

**Symptom:** Browser shows "Connection refused" or timeout

**Solutions:**

1. **Verify the service is running:**
   ```bash
   docker compose -f docker-compose.coolify.yml ps
   ```

2. **Check port binding:**
   ```bash
   docker compose -f docker-compose.coolify.yml port n8n 5678
   ```

3. **Verify firewall rules:**
   - Ensure port 5678 is open (if not using Coolify proxy)
   - Check Coolify's proxy configuration

4. **Test local connectivity:**
   ```bash
   # n8n provides a standard /healthz endpoint for health checks
   curl http://localhost:5678/healthz
   ```
   
   Expected response: `{"status":"ok"}`

### Database Connection Errors

**Symptom:** n8n shows database connection errors

**Solutions:**

1. **Verify PostgreSQL is running:**
   ```bash
   docker compose -f docker-compose.coolify.yml exec postgres pg_isready
   ```

2. **Check database credentials:**
   - Verify `POSTGRES_PASSWORD` matches in both services
   - Ensure `POSTGRES_USER` and `POSTGRES_DB` are correct

3. **Check network connectivity:**
   ```bash
   docker compose -f docker-compose.coolify.yml exec n8n ping postgres
   ```

### Webhook Issues

**Symptom:** Webhooks return 404 or don't trigger workflows

**Solutions:**

1. **Verify `WEBHOOK_URL` is correct:**
   - Must match your actual public URL
   - Include the correct protocol (http/https)
   - Example: `https://workflow.yourdomain.com`

2. **Check DNS configuration:**
   - Ensure your domain points to your server
   - Verify Coolify's proxy is working

3. **Test webhook endpoint:**
   
   First, create a test workflow with a webhook trigger in n8n, then test it:
   ```bash
   curl https://your-domain.com/webhook/your-webhook-path
   ```
   
   Replace `your-webhook-path` with the actual webhook path from your workflow.

### Lost Encryption Key

**Symptom:** Cannot access saved credentials

**Solution:**

⚠️ **CRITICAL:** If you lose or change the `N8N_ENCRYPTION_KEY`, encrypted credentials in the database become inaccessible.

**Prevention:**
- Backup your `.env` file securely
- Store the encryption key in a password manager
- Document it in your organization's secure vault

**If lost:**
- You'll need to re-enter all credentials manually
- Consider restoring from a backup if available

### High Memory Usage

**Symptom:** Services consuming excessive memory

**Solutions:**

1. **Monitor resource usage:**
   ```bash
   docker stats
   ```

2. **Add memory limits to docker-compose.coolify.yml:**
   ```yaml
   services:
     n8n:
       mem_limit: 2g
       mem_reservation: 1g
   ```

3. **Optimize execution settings:**
   - Reduce `EXECUTIONS_DATA_SAVE_ON_SUCCESS` if storing too much data
   - Implement execution data pruning

### SSL/TLS Certificate Issues

**Symptom:** Browser shows SSL warnings

**Solutions:**

1. **Use Coolify's automatic SSL:**
   - Ensure domain is properly configured
   - Coolify will automatically provision Let's Encrypt certificates

2. **Verify domain DNS:**
   ```bash
   nslookup your-domain.com
   ```

3. **Check Coolify proxy logs** in the dashboard

## Upgrading n8n

### Standard Upgrade Process

1. **Backup your data** (see [Backup Strategy](#backup-strategy))

2. **Update the image:**
   
   In Coolify's docker-compose configuration, the image is set to `:latest`:
   ```yaml
   image: ghcr.io/n8n-io/n8n:latest
   ```

3. **Redeploy:**
   - Click "Restart" or "Redeploy" in Coolify
   - Coolify will pull the latest image and restart the service

4. **Verify the upgrade:**
   - Check logs for any errors
   - Test your workflows
   - Verify all integrations still work

### Pinning to a Specific Version

For production stability, you may want to pin to a specific version:

```yaml
image: ghcr.io/n8n-io/n8n:1.0.0  # Replace with desired version
```

Check available versions at: https://github.com/n8n-io/n8n/releases

### Rolling Back

If an upgrade causes issues:

1. **Change image tag** to previous version:
   ```yaml
   image: ghcr.io/n8n-io/n8n:1.0.0  # Replace with your previous working version
   ```

2. **Redeploy in Coolify**

3. **Restore from backup if needed**

## Security Best Practices

### 1. Use Strong Credentials

- Generate complex passwords (20+ characters)
- Use a password manager
- Rotate credentials periodically

### 2. Enable HTTPS

- Always use `https` protocol in production
- Let Coolify handle SSL/TLS certificates automatically
- Never use `http` for production deployments

### 3. Secure the Encryption Key

- Never commit `.env` to version control
- Store encryption key in a secure vault
- Backup encryption key separately from data

### 4. Restrict Access

- Use firewall rules to limit access
- Consider VPN or IP whitelisting for admin access
- Implement additional authentication layers if needed

### 5. Regular Updates

- Keep n8n updated to latest stable version
- Monitor security advisories
- Update PostgreSQL periodically

### 6. Network Security

- Use Coolify's network isolation features
- Don't expose PostgreSQL port publicly
- Only expose necessary ports (5678 for n8n)

### 7. Backup Strategy

- Implement automated daily backups
- Store backups off-site
- Test restoration procedures regularly

### 8. Monitoring

- Set up monitoring for service health
- Monitor resource usage
- Set up alerts for service failures

## Additional Resources

- **n8n Documentation:** https://docs.n8n.io
- **n8n Community Forum:** https://community.n8n.io
- **Coolify Documentation:** https://coolify.io/docs
- **n8n GitHub Repository:** https://github.com/n8n-io/n8n
- **Docker Compose Documentation:** https://docs.docker.com/compose/

## Support

If you encounter issues not covered in this guide:

1. Check the [n8n Community Forum](https://community.n8n.io)
2. Review [n8n's official documentation](https://docs.n8n.io)
3. Check [Coolify's documentation](https://coolify.io/docs)
4. Open an issue on the [n8n GitHub repository](https://github.com/n8n-io/n8n/issues)

## Contributing

Found an issue with this deployment guide? Please open a pull request or issue on the repository!

---

**Happy Automating with n8n on Coolify! 🚀**
