# n8n Deployment Guide

This repository is configured for easy deployment on multiple platforms, with special emphasis on Coolify deployment.

## 🚀 Quick Deployment Options

### Option 1: Coolify (Recommended for Self-Hosting)

**Best for:** Production self-hosted deployments with minimal setup

See the detailed [Coolify Deployment Guide](README-COOLIFY.md) for step-by-step instructions.

**Quick Start:**
```bash
# Run the quickstart script to set up environment variables
./coolify-quickstart.sh

# Then deploy in Coolify using the docker-compose.yml file
```

### Option 2: Docker Compose (Manual)

**Best for:** Local development or manual server deployments

```bash
# 1. Copy and configure environment variables
cp .env.example .env
# Edit .env with your values

# 2. Start the services
docker compose up -d

# 3. Access n8n at http://localhost:5678
```

### Option 3: Official n8n Docker Image

**Best for:** Quick testing or simple deployments

```bash
docker volume create n8n_data
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=your-db-host \
  -e DB_POSTGRESDB_DATABASE=n8n \
  -e DB_POSTGRESDB_USER=n8n \
  -e DB_POSTGRESDB_PASSWORD=your-password \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

### Option 4: Build from Source

**Best for:** Custom builds or development

```bash
# 1. Install dependencies
pnpm install

# 2. Build the application
pnpm build

# 3. Build Docker image from source
docker build -f Dockerfile.build -t n8n-custom .

# 4. Run your custom build
docker run -it --rm -p 5678:5678 n8n-custom
```

## 📋 Required Configuration

### Minimum Required Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `POSTGRES_PASSWORD` | Database password | `secure_password_123` |
| `N8N_ENCRYPTION_KEY` | Credentials encryption key | (32 random characters) |
| `WEBHOOK_URL` | Public webhook URL | `https://n8n.domain.com/` |

### Generate Secure Keys

```bash
# Generate encryption key
openssl rand -base64 32

# Generate password
openssl rand -base64 24
```

## 🏗️ Architecture

The deployment includes:

- **n8n**: Workflow automation application
- **PostgreSQL**: Database for workflow and credential storage
- **Volumes**: Persistent data storage
- **Health Checks**: Automatic service monitoring
- **Networks**: Isolated container communication

## 🔐 Security Checklist

- [ ] Use HTTPS in production (`N8N_PROTOCOL=https`)
- [ ] Set strong database password
- [ ] Generate random encryption key (32+ characters)
- [ ] Enable basic authentication for additional security
- [ ] Keep n8n updated to latest stable version
- [ ] Regular database backups
- [ ] Monitor logs for suspicious activity
- [ ] Use firewall to restrict access

## 📊 Scaling Options

### Queue Mode (High Volume)

For production deployments with many workflows:

1. Uncomment Redis service in `docker-compose.yml`
2. Set environment variables:
   ```bash
   EXECUTIONS_MODE=queue
   QUEUE_BULL_REDIS_HOST=redis
   QUEUE_BULL_REDIS_PORT=6379
   ```
3. Scale workers: `docker compose up -d --scale n8n=3`

### Database Scaling

For better performance:
- Use dedicated PostgreSQL instance
- Enable connection pooling
- Configure appropriate shared_buffers and work_mem
- Regular VACUUM and ANALYZE

## 🔧 Maintenance

### Backup Database

```bash
# Export database
docker exec -t postgres-container-id pg_dump -U n8n n8n > backup.sql

# Full cluster backup
docker exec -t postgres-container-id pg_dumpall -c -U n8n > full_backup.sql
```

### Restore Database

```bash
cat backup.sql | docker exec -i postgres-container-id psql -U n8n -d n8n
```

### Update n8n

```bash
# Pull latest image
docker compose pull

# Restart services
docker compose down
docker compose up -d
```

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f n8n

# Last 100 lines
docker compose logs --tail=100 n8n
```

## 🐛 Troubleshooting

### Service won't start
```bash
# Check logs
docker compose logs n8n

# Check service status
docker compose ps

# Verify environment variables
docker compose config
```

### Database connection errors
```bash
# Verify database is healthy
docker compose ps postgres

# Check database logs
docker compose logs postgres

# Test database connection
docker compose exec postgres psql -U n8n -d n8n -c "SELECT 1;"
```

### Webhook issues
- Verify `WEBHOOK_URL` matches your actual domain
- Ensure `N8N_PROTOCOL` is set correctly (http/https)
- Check firewall and proxy settings
- Test with a simple webhook workflow

### Permission errors
```bash
# Fix volume permissions
docker compose down
docker volume rm n8n_n8n_data
docker compose up -d
```

## 📚 Additional Resources

- [n8n Official Documentation](https://docs.n8n.io/)
- [n8n Environment Variables](https://docs.n8n.io/hosting/configuration/environment-variables/)
- [Coolify Documentation](https://coolify.io/docs)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [PostgreSQL Tuning](https://pgtune.leopard.in.ua/)

## 🆘 Getting Help

- **n8n Community**: [community.n8n.io](https://community.n8n.io)
- **GitHub Issues**: [n8n-io/n8n/issues](https://github.com/n8n-io/n8n/issues)
- **Coolify Discord**: [coolify.io/discord](https://coolify.io/discord)

## 📄 Files in This Repository

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Main orchestration file for all services |
| `Dockerfile` | Simple Dockerfile using official n8n image |
| `Dockerfile.build` | Build n8n from source (advanced) |
| `.env.example` | Example environment variables with documentation |
| `README-COOLIFY.md` | Detailed Coolify deployment guide |
| `coolify-quickstart.sh` | Interactive setup script |
| `healthcheck.sh` | Health check script for containers |
| `.coolify` | Coolify configuration hints |

## 🎯 Production Checklist

Before going to production:

- [ ] Environment variables configured and secured
- [ ] HTTPS/SSL enabled
- [ ] Basic authentication enabled
- [ ] Database backups scheduled
- [ ] Monitoring and alerting set up
- [ ] Resource limits configured
- [ ] Log rotation enabled
- [ ] Security updates automated
- [ ] Disaster recovery plan documented
- [ ] Load testing completed (if high volume expected)

---

**Need help?** Open an issue or check our community forums!
