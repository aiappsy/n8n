# Coolify Deployment Quick Reference

Quick commands and configurations for n8n on Coolify.

## 🚀 Quick Start Commands

```bash
# Clone repository
git clone https://github.com/aiappsy/n8n.git && cd n8n

# Run interactive setup
./coolify-quickstart.sh

# Test locally
docker compose up -d

# View logs
docker compose logs -f n8n

# Stop services
docker compose down
```

## 🔑 Generate Secure Values

```bash
# Encryption key (32 characters)
openssl rand -base64 32

# Password (24 characters)
openssl rand -base64 24

# Hex key (64 characters)
openssl rand -hex 32
```

## 📋 Essential Environment Variables

### Required
```bash
POSTGRES_PASSWORD=your_secure_password_here
N8N_ENCRYPTION_KEY=your_32_character_encryption_key
WEBHOOK_URL=https://your-domain.com/
```

### Recommended
```bash
N8N_PROTOCOL=https
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_basic_auth_password
GENERIC_TIMEZONE=America/New_York
```

## 🐳 Docker Commands

```bash
# Validate compose file
docker compose config

# Start services
docker compose up -d

# View logs
docker compose logs -f [service_name]

# Check service status
docker compose ps

# Restart service
docker compose restart n8n

# Stop all services
docker compose down

# Stop and remove volumes
docker compose down -v

# Update images
docker compose pull
docker compose up -d
```

## 💾 Database Operations

```bash
# Backup database
docker compose exec postgres pg_dump -U n8n n8n > backup_$(date +%Y%m%d).sql

# Full backup with all databases
docker compose exec postgres pg_dumpall -U n8n > full_backup_$(date +%Y%m%d).sql

# Restore database
cat backup.sql | docker compose exec -T postgres psql -U n8n -d n8n

# Connect to database
docker compose exec postgres psql -U n8n -d n8n

# Check database size
docker compose exec postgres psql -U n8n -d n8n -c "SELECT pg_size_pretty(pg_database_size('n8n'));"
```

## 🔍 Debugging Commands

```bash
# Check n8n logs
docker compose logs -f --tail=100 n8n

# Check PostgreSQL logs
docker compose logs -f --tail=100 postgres

# Check all logs
docker compose logs -f --tail=100

# Execute shell in n8n container
docker compose exec n8n sh

# Check environment variables
docker compose exec n8n env | grep N8N

# Test health endpoint
curl http://localhost:5678/healthz

# Test webhook
curl -X POST http://localhost:5678/webhook-test/your-webhook-id
```

## 📊 Monitoring Commands

```bash
# Check resource usage
docker compose stats

# Check disk usage
docker system df

# Check container health
docker compose ps

# View specific service details
docker compose ps n8n

# Inspect network
docker network inspect n8n_n8n-network
```

## 🔧 Maintenance Commands

```bash
# Prune unused Docker resources
docker system prune -a

# Prune volumes (CAREFUL: deletes unused volumes)
docker volume prune

# Update to latest n8n version
docker compose pull n8n
docker compose up -d n8n

# Restart all services
docker compose restart

# Recreate containers
docker compose up -d --force-recreate
```

## 🌐 Network Troubleshooting

```bash
# Test DNS resolution
nslookup your-domain.com

# Test connection to n8n
curl -I https://your-domain.com

# Test webhook from outside
curl -X POST https://your-domain.com/webhook-test/test

# Check open ports
netstat -tulpn | grep :5678

# Test database connection from n8n
docker compose exec n8n nc -zv postgres 5432
```

## 📝 Coolify-Specific Tips

### In Coolify Dashboard

1. **View Logs**: Navigate to your service → Logs tab
2. **Environment Variables**: Service → Environment tab
3. **Restart Service**: Service → Actions → Restart
4. **Redeploy**: Service → Actions → Deploy
5. **Terminal Access**: Service → Terminal tab

### Common Coolify Actions

```bash
# Force redeploy from Coolify
# (Use Coolify UI: Service → Deploy button)

# Update environment variable
# (Use Coolify UI: Service → Environment → Save → Restart)

# View real-time logs
# (Use Coolify UI: Service → Logs → Enable auto-refresh)
```

## ⚙️ Configuration Snippets

### Enable Queue Mode
```yaml
# In docker-compose.yml, uncomment Redis service
# Then add these environment variables:
EXECUTIONS_MODE=queue
QUEUE_BULL_REDIS_HOST=redis
QUEUE_BULL_REDIS_PORT=6379
```

### Enable Metrics
```yaml
N8N_METRICS=true
N8N_METRICS_PREFIX=n8n_
```

### Configure SMTP
```yaml
N8N_EMAIL_MODE=smtp
N8N_SMTP_HOST=smtp.gmail.com
N8N_SMTP_PORT=587
N8N_SMTP_USER=your-email@gmail.com
N8N_SMTP_PASS=your-app-password
```

## 🚨 Emergency Procedures

### Service Not Starting
```bash
# 1. Check logs
docker compose logs n8n

# 2. Verify environment variables
docker compose config

# 3. Restart from scratch
docker compose down -v
docker compose up -d
```

### Database Connection Error
```bash
# 1. Check if PostgreSQL is running
docker compose ps postgres

# 2. Test connection
docker compose exec postgres pg_isready -U n8n

# 3. Check credentials
docker compose exec n8n env | grep DB_POSTGRES
```

### Out of Disk Space
```bash
# Check disk usage
df -h

# Clean Docker
docker system prune -a
docker volume prune

# Check log sizes
docker compose exec n8n du -sh /home/node/.n8n/logs
```

### Webhook Not Working
```bash
# 1. Verify WEBHOOK_URL
docker compose exec n8n env | grep WEBHOOK_URL

# 2. Test from outside
curl -X POST https://your-domain.com/webhook-test/test

# 3. Check firewall
curl -I https://your-domain.com
```

## 📱 Status Check One-Liner

```bash
# Quick health check
echo "n8n: $(curl -s http://localhost:5678/healthz && echo OK || echo FAIL)" && \
echo "Postgres: $(docker compose exec postgres pg_isready -U n8n | grep accepting && echo OK || echo FAIL)" && \
docker compose ps
```

## 📚 File Locations

```
Repository Files:
├── docker-compose.yml              # Main orchestration
├── Dockerfile                      # Simple Dockerfile
├── Dockerfile.build                # Build from source
├── .env.example                    # Environment template
├── README-COOLIFY.md               # Deployment guide
├── DEPLOYMENT.md                   # General deployment
├── COOLIFY-CHECKLIST.md           # Pre/post deployment checklist
├── COOLIFY-QUICK-REFERENCE.md     # This file
├── coolify-quickstart.sh          # Setup script
└── healthcheck.sh                 # Health check script

Container Paths:
├── /home/node/.n8n/               # n8n user data
├── /usr/local/lib/node_modules/n8n/ # n8n installation
└── /var/lib/postgresql/data       # PostgreSQL data
```

## 🔗 Important URLs

| Resource | URL |
|----------|-----|
| n8n Docs | https://docs.n8n.io |
| Coolify Docs | https://coolify.io/docs |
| n8n Community | https://community.n8n.io |
| Docker Hub | https://hub.docker.com/r/n8nio/n8n |
| GitHub Issues | https://github.com/n8n-io/n8n/issues |

---

**Pro Tip:** Bookmark this page for quick access during deployment and maintenance!

**Need more details?** See [README-COOLIFY.md](README-COOLIFY.md) for comprehensive guide.
