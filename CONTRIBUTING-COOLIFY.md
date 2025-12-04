# Contributing to n8n Coolify Deployment

Thank you for your interest in improving n8n's Coolify deployment configuration! This guide will help you contribute effectively.

## 📋 What Can You Contribute?

- **Bug Fixes**: Issues with the deployment configuration
- **Documentation**: Improvements to deployment guides
- **Features**: New deployment options or configurations
- **Testing**: Validation of deployment on different platforms
- **Examples**: Real-world deployment scenarios

## 🏗️ Repository Structure

```
n8n/
├── docker-compose.yml          # Main Coolify deployment config
├── Dockerfile                  # Simple Dockerfile using official image
├── Dockerfile.build            # Build from source option
├── .env.example               # Environment variables template
├── README-COOLIFY.md          # Coolify deployment guide
├── DEPLOYMENT.md              # General deployment guide
├── coolify-quickstart.sh      # Interactive setup script
├── healthcheck.sh             # Container health check
└── .coolify                   # Coolify configuration hints
```

## 🧪 Testing Your Changes

### 1. Validate Docker Compose Syntax

```bash
# Create test environment file
cat > .env.test << EOF
POSTGRES_PASSWORD=test123
N8N_ENCRYPTION_KEY=testkey32characterslong123456
WEBHOOK_URL=http://localhost:5678/
EOF

# Validate syntax
docker compose --env-file .env.test config

# Clean up
rm .env.test
```

### 2. Test Docker Build

```bash
# Test main Dockerfile
docker build --check -t n8n-test .

# Test build from source
docker build --check -f Dockerfile.build -t n8n-test-build .
```

### 3. Test Deployment Locally

```bash
# Create environment file
cp .env.example .env
# Edit .env with test values

# Start services
docker compose up -d

# Check logs
docker compose logs -f

# Test health endpoints
curl http://localhost:5678/healthz

# Clean up
docker compose down -v
```

### 4. Test Quickstart Script

```bash
# Run in test mode (review changes without modifying files)
bash -n coolify-quickstart.sh

# Run actual script
./coolify-quickstart.sh
```

## 📝 Guidelines for Contributions

### Environment Variables

- **Always document** new environment variables in `.env.example`
- **Mark required variables** with appropriate syntax: `${VAR:?error message}`
- **Provide sensible defaults** where applicable
- **Group related variables** with clear comments

### Docker Configuration

- **Keep builds minimal**: Use official images when possible
- **Multi-stage builds**: Reduce final image size
- **Health checks**: Always include for services
- **Security**: Run as non-root user, minimize attack surface

### Documentation

- **Clear and concise**: Use bullet points and tables
- **Examples**: Provide real-world examples
- **Troubleshooting**: Add common issues and solutions
- **Links**: Reference official documentation

### Scripts

- **Error handling**: Use `set -e` and proper error messages
- **User-friendly**: Clear prompts and confirmations
- **Portable**: Test on different shells and platforms
- **Documented**: Add comments for complex logic

## 🔍 Code Review Checklist

Before submitting a PR, ensure:

- [ ] Changes are tested locally
- [ ] Documentation is updated
- [ ] Environment variables are documented
- [ ] No sensitive data in files
- [ ] Scripts are executable (`chmod +x`)
- [ ] Docker syntax is valid
- [ ] Health checks work correctly
- [ ] No breaking changes (or clearly marked)

## 🐛 Reporting Issues

When reporting deployment issues, include:

1. **Environment**: OS, Docker version, Coolify version
2. **Configuration**: Relevant environment variables (sanitized)
3. **Logs**: Container logs and error messages
4. **Steps to reproduce**: Detailed reproduction steps
5. **Expected vs actual**: What you expected and what happened

### Issue Template

```markdown
## Description
[Clear description of the issue]

## Environment
- OS: [e.g., Ubuntu 22.04]
- Docker: [e.g., 24.0.7]
- Docker Compose: [e.g., v2.23.0]
- Coolify: [e.g., v4.0.0]

## Configuration
```yaml
# Relevant parts of docker-compose.yml or .env (sanitized)
```

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]

## Logs
```
[Relevant log output]
```

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]
```

## 💡 Improvement Ideas

Areas where contributions are welcome:

### High Priority
- [ ] Add Redis queue mode examples
- [ ] Kubernetes/Helm chart support
- [ ] Better error messages in health checks
- [ ] Automated backup solutions
- [ ] Performance tuning guides

### Medium Priority
- [ ] Multiple database backend examples
- [ ] Reverse proxy configurations
- [ ] Monitoring and alerting integration
- [ ] CI/CD pipeline examples
- [ ] Migration guides from other platforms

### Low Priority
- [ ] Alternative cloud provider examples
- [ ] Development environment setup
- [ ] Advanced networking scenarios
- [ ] Custom node development guide

## 🚀 Submitting Changes

### 1. Fork the Repository

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR-USERNAME/n8n.git
cd n8n
git remote add upstream https://github.com/aiappsy/n8n.git
```

### 2. Create a Branch

```bash
git checkout -b feature/coolify-improvement
```

### 3. Make Changes

- Follow the guidelines above
- Test thoroughly
- Update documentation

### 4. Commit Changes

```bash
git add .
git commit -m "feat(coolify): add Redis queue mode example

- Add docker-compose configuration for Redis
- Update documentation with queue mode setup
- Add environment variables for Redis connection"
```

### 5. Push and Create PR

```bash
git push origin feature/coolify-improvement
```

Then create a Pull Request on GitHub with:
- Clear title and description
- Reference related issues
- Screenshots if applicable
- Testing details

## 📚 Resources

### Official Documentation
- [n8n Documentation](https://docs.n8n.io/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Coolify Docs](https://coolify.io/docs)

### Learning Resources
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [12 Factor App](https://12factor.net/)
- [Container Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)

## 🙏 Recognition

Contributors who improve the Coolify deployment will be:
- Listed in the project contributors
- Mentioned in release notes
- Helping thousands of n8n users deploy successfully

Thank you for contributing to making n8n easier to deploy! 🎉
