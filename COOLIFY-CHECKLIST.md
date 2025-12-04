# Coolify Deployment Checklist

Use this checklist to ensure your n8n deployment on Coolify is properly configured and ready for production.

## 📋 Pre-Deployment Checklist

### Repository Setup
- [ ] Repository is accessible to Coolify (public or connected via Git)
- [ ] Branch selected for deployment (usually `main` or `master`)
- [ ] All necessary files are present:
  - [ ] `docker-compose.yml`
  - [ ] `Dockerfile`
  - [ ] `.env.example`
  - [ ] `README-COOLIFY.md`

### Environment Configuration
- [ ] `.env` file created (or environment variables set in Coolify)
- [ ] `POSTGRES_PASSWORD` set to a strong, unique password (min 16 chars)
- [ ] `N8N_ENCRYPTION_KEY` generated and set (exactly 32 characters)
  ```bash
  # Generate with: openssl rand -base64 32
  ```
- [ ] `WEBHOOK_URL` configured with your actual domain
- [ ] `N8N_PROTOCOL` set to `https` (if using SSL)

### Optional but Recommended
- [ ] Basic authentication enabled:
  - [ ] `N8N_BASIC_AUTH_ACTIVE=true`
  - [ ] `N8N_BASIC_AUTH_USER` set
  - [ ] `N8N_BASIC_AUTH_PASSWORD` set (strong password)
- [ ] Timezone configured:
  - [ ] `GENERIC_TIMEZONE` set to your timezone
  - [ ] `TZ` set to your timezone
- [ ] Email configuration (if using email features)
  - [ ] SMTP settings configured

## 🚀 Deployment Checklist

### Coolify Configuration
- [ ] Created new resource in Coolify
- [ ] Selected "Docker Compose" as deployment type
- [ ] Pointed to correct repository
- [ ] Selected correct branch
- [ ] Docker Compose file path set to `/docker-compose.yml`

### Domain Setup
- [ ] Domain added in Coolify
- [ ] SSL/TLS certificate enabled (Let's Encrypt)
- [ ] DNS records configured:
  - [ ] A record pointing to server IP
  - [ ] CNAME or A record for webhooks (if different)
- [ ] `WEBHOOK_URL` matches configured domain

### Environment Variables in Coolify
- [ ] All required variables added:
  ```
  POSTGRES_PASSWORD=your_secure_password
  N8N_ENCRYPTION_KEY=your_32_char_key
  WEBHOOK_URL=https://your-domain.com/
  N8N_PROTOCOL=https
  ```
- [ ] Optional variables added as needed
- [ ] No variables contain placeholder values

### Initial Deployment
- [ ] Triggered first deployment
- [ ] Checked deployment logs for errors
- [ ] Verified PostgreSQL container started successfully
- [ ] Verified n8n container started successfully
- [ ] Both services report as healthy

## ✅ Post-Deployment Verification

### Access and Authentication
- [ ] Can access n8n at configured domain
- [ ] HTTPS works correctly (no certificate warnings)
- [ ] Basic authentication works (if enabled)
- [ ] Can create admin account
- [ ] Can log in successfully

### Functionality Tests
- [ ] Can create a new workflow
- [ ] Can save a workflow
- [ ] Can activate a workflow
- [ ] Can execute a workflow manually
- [ ] Can create a webhook trigger
- [ ] Webhook URL is correct in trigger nodes
- [ ] Webhook actually receives requests
- [ ] Can install community nodes (if needed)

### Data Persistence
- [ ] Created test workflow and saved it
- [ ] Restarted n8n service in Coolify
- [ ] Test workflow still exists after restart
- [ ] Credentials are preserved (encrypted properly)

### Performance
- [ ] Page loads in reasonable time (< 3 seconds)
- [ ] Workflow execution completes successfully
- [ ] No timeout errors
- [ ] Resource usage is acceptable

## 🔒 Security Checklist

### Network Security
- [ ] Firewall configured to allow only necessary ports
- [ ] HTTPS enabled and enforced
- [ ] No plain HTTP traffic accepted
- [ ] Database not exposed to public internet
- [ ] Only necessary ports exposed in docker-compose

### Authentication & Authorization
- [ ] Strong admin password set
- [ ] Basic authentication enabled (recommended)
- [ ] Two-factor authentication configured (if available)
- [ ] User permissions configured appropriately

### Data Security
- [ ] Encryption key is unique and never shared
- [ ] Database password is strong and unique
- [ ] Credentials stored encrypted in database
- [ ] No sensitive data in logs
- [ ] `.env` file not committed to Git

### Updates & Maintenance
- [ ] Update strategy defined
- [ ] Backup strategy in place
- [ ] Monitoring configured
- [ ] Alert notifications set up

## 💾 Backup Checklist

### Database Backups
- [ ] Automatic database backups configured
- [ ] Backup schedule defined (daily recommended)
- [ ] Backup retention policy set
- [ ] Backup restoration tested
- [ ] Backup storage location secure

### Configuration Backups
- [ ] Environment variables documented
- [ ] Encryption key backed up securely
- [ ] Docker compose configuration versioned
- [ ] Coolify configuration exported

### Backup Test
- [ ] Performed test backup
- [ ] Performed test restoration
- [ ] Verified restored data integrity
- [ ] Documented restoration procedure

## 📊 Monitoring Checklist

### Health Monitoring
- [ ] Service health checks working
- [ ] Coolify monitoring active
- [ ] Uptime monitoring configured (optional)
- [ ] Alert thresholds defined

### Log Monitoring
- [ ] Can access logs in Coolify
- [ ] Log rotation configured
- [ ] Error tracking set up
- [ ] Log retention policy defined

### Performance Monitoring
- [ ] CPU usage monitored
- [ ] Memory usage monitored
- [ ] Disk space monitored
- [ ] Database performance monitored

### Optional Advanced Monitoring
- [ ] Prometheus metrics enabled (`N8N_METRICS=true`)
- [ ] Grafana dashboard set up
- [ ] Custom alerts configured
- [ ] APM tool integrated

## 📈 Scaling Checklist (Optional)

For high-volume deployments:

### Queue Mode Setup
- [ ] Redis service added to docker-compose
- [ ] `EXECUTIONS_MODE=queue` set
- [ ] Redis connection configured
- [ ] Worker nodes scaled appropriately

### Database Optimization
- [ ] Using dedicated PostgreSQL instance
- [ ] Connection pooling enabled
- [ ] Database tuning performed
- [ ] Regular VACUUM scheduled

### Infrastructure
- [ ] Adequate server resources allocated
- [ ] Load balancing configured (if multiple instances)
- [ ] CDN configured for static assets
- [ ] Database read replicas (if needed)

## 🐛 Troubleshooting Checklist

If issues occur, verify:

### Common Issues
- [ ] All environment variables are set correctly
- [ ] Domain DNS is propagated
- [ ] SSL certificates are valid
- [ ] Database is accessible from n8n container
- [ ] Ports are not blocked by firewall
- [ ] Sufficient disk space available
- [ ] Sufficient memory available

### Debug Steps
- [ ] Check Coolify deployment logs
- [ ] Check n8n container logs
- [ ] Check PostgreSQL container logs
- [ ] Test database connection manually
- [ ] Verify environment variables in container
- [ ] Test webhook URL externally
- [ ] Check network connectivity between containers

## 📝 Documentation Checklist

### Internal Documentation
- [ ] Deployment procedure documented
- [ ] Credentials stored securely
- [ ] Team access configured
- [ ] Emergency contacts defined
- [ ] Escalation procedures documented

### External Documentation
- [ ] User access instructions created
- [ ] Workflow creation guidelines shared
- [ ] Best practices documented
- [ ] FAQ created for common issues

## 🎯 Production Readiness

Before going live:

### Final Verification
- [ ] All checklist items above completed
- [ ] Load testing performed (if high volume expected)
- [ ] Disaster recovery plan documented
- [ ] Support procedures defined
- [ ] Monitoring dashboards reviewed
- [ ] Backup restoration tested
- [ ] Security audit completed
- [ ] Performance acceptable under load

### Go-Live
- [ ] Deployment scheduled
- [ ] Stakeholders notified
- [ ] Rollback plan prepared
- [ ] Team available for monitoring
- [ ] Post-deployment verification planned

---

## 📚 Additional Resources

- [README-COOLIFY.md](README-COOLIFY.md) - Detailed deployment guide
- [DEPLOYMENT.md](DEPLOYMENT.md) - General deployment information
- [CONTRIBUTING-COOLIFY.md](CONTRIBUTING-COOLIFY.md) - Contribution guidelines
- [n8n Documentation](https://docs.n8n.io/) - Official n8n docs
- [Coolify Documentation](https://coolify.io/docs) - Official Coolify docs

---

**Last Updated:** December 2024

**Note:** This checklist should be reviewed and updated regularly as your deployment evolves.
