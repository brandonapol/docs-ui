# Docker Deployment Guide

This guide explains how to build and deploy the documentation site using Docker and Docker Compose.

## Overview

The project includes a complete Docker setup with:

- **Multi-stage Dockerfile** for optimized production builds
- **Docker Compose** configuration for development and production
- **Nginx** web server with optimized configuration
- **Security headers** and caching strategies

## Quick Start

### Production Deployment

Build and run the production container:

```bash
# Build and start production service
docker-compose up -d docs-ui-prod

# View logs
docker-compose logs -f docs-ui-prod

# Stop the service
docker-compose down
```

Your documentation site will be available at `http://localhost`.

### Development Environment

Run the development server with hot reload:

```bash
# Start development service with live reload
docker-compose --profile dev up docs-ui-dev

# Or run in detached mode
docker-compose --profile dev up -d docs-ui-dev
```

Development server will be available at `http://localhost:3000`.

## Dockerfile Stages

### Stage 1: Builder
- **Base**: `node:18-alpine`
- **Purpose**: Build the static site using Nuxt.js
- **Output**: Generated static files in `.output/public`

### Stage 2: Production
- **Base**: `nginx:1.25-alpine`  
- **Purpose**: Serve static files with optimized nginx configuration
- **Features**: Compression, caching, security headers

## Docker Compose Services

### `docs-ui-prod` (Production)

```yaml
services:
  docs-ui-prod:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    ports:
      - "80:80"
    restart: unless-stopped
```

**Features:**
- Production-optimized nginx serving
- Health checks
- Automatic restart policy
- Network isolation

### `docs-ui-dev` (Development)

```yaml
services:
  docs-ui-dev:
    build:
      context: .
      dockerfile: Dockerfile  
      target: builder
    ports:
      - "3000:3000"
    volumes:
      - .:/app
    command: npm run dev
```

**Features:**
- Live code reloading
- Volume mounting for development
- Hot module replacement

## Advanced Configuration

### Environment Variables

Set environment variables in your deployment:

```bash
# Production
NODE_ENV=production

# Development  
NODE_ENV=development
NUXT_HOST=0.0.0.0
NUXT_PORT=3000
```

### Custom Domain with Traefik

The production service includes Traefik labels for automatic SSL:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.docs-ui.rule=Host(`docs.example.com`)"
  - "traefik.http.routers.docs-ui.tls=true"
  - "traefik.http.routers.docs-ui.tls.certresolver=letsencrypt"
```

### Health Checks

The production container includes built-in health monitoring:

```bash
# Check container health
docker-compose ps

# Manual health check
curl -f http://localhost/health
```

## Nginx Configuration

### Performance Optimizations

- **Gzip compression** for text assets
- **Long-term caching** for static assets (1 year)
- **Short-term caching** for HTML files (1 hour)
- **HTTP/2** support ready

### Security Features

- **Security headers**: XSS protection, content type sniffing prevention
- **HSTS**: Strict transport security
- **Hidden nginx version**
- **Access controls** for sensitive files

### Cache Strategy

| File Type | Cache Duration | Strategy |
|-----------|---------------|----------|
| CSS, JS, Images | 1 year | `immutable` |
| HTML files | 1 hour | `public, max-age=3600` |
| API routes | No cache | `no-store, no-cache` |

## Production Deployment

### Basic Deployment

```bash
# Clone the repository
git clone <your-repo-url>
cd docs-ui

# Build and start production
docker-compose up -d docs-ui-prod

# Verify deployment
curl -I http://localhost
```

### With Reverse Proxy

If using a reverse proxy (nginx, Traefik, etc.):

```bash
# Start on custom port
docker-compose up -d docs-ui-prod
# Then configure your reverse proxy to forward to localhost:80
```

### Cloud Deployment

#### AWS ECS/Fargate

```bash
# Build for AWS ECR
docker build -t your-account.dkr.ecr.region.amazonaws.com/docs-ui:latest .
docker push your-account.dkr.ecr.region.amazonaws.com/docs-ui:latest
```

#### Google Cloud Run

```bash
# Build for Google Container Registry
docker build -t gcr.io/your-project/docs-ui:latest .
docker push gcr.io/your-project/docs-ui:latest
gcloud run deploy docs-ui --image gcr.io/your-project/docs-ui:latest
```

#### DigitalOcean App Platform

```yaml
# app.yaml
name: docs-ui
services:
- name: web
  source_dir: /
  dockerfile_path: Dockerfile
  http_port: 80
  instance_count: 1
  instance_size_slug: basic-xxs
```

## Development Workflow

### Local Development with Docker

```bash
# Start development environment
docker-compose --profile dev up docs-ui-dev

# Make changes to your files
# Changes will be reflected immediately

# Run commands inside container
docker-compose exec docs-ui-dev npm run build
docker-compose exec docs-ui-dev npm run generate
```

### Building for Production

```bash
# Build production image
docker build -t docs-ui:latest .

# Test production build locally
docker run -p 8080:80 docs-ui:latest

# Access at http://localhost:8080
```

## Troubleshooting

### Common Issues

#### Build Failures

```bash
# Clear Docker cache
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache docs-ui-prod
```

#### Permission Issues

```bash
# Fix file permissions
sudo chown -R $USER:$USER .

# Rebuild containers
docker-compose down
docker-compose up -d docs-ui-prod
```

#### Memory Issues

```bash
# Increase Docker memory limit
# Docker Desktop: Settings > Resources > Memory

# Or use build args for Node.js
docker build --build-arg NODE_OPTIONS="--max-old-space-size=4096" .
```

### Debugging

#### Container Logs

```bash
# View production logs
docker-compose logs -f docs-ui-prod

# View development logs  
docker-compose logs -f docs-ui-dev

# View nginx access logs
docker-compose exec docs-ui-prod tail -f /var/log/nginx/access.log
```

#### Interactive Shell

```bash
# Access production container
docker-compose exec docs-ui-prod sh

# Access development container
docker-compose exec docs-ui-dev sh

# Check nginx configuration
docker-compose exec docs-ui-prod nginx -t
```

## Performance Monitoring

### Metrics Collection

Monitor your deployment with:

```bash
# Container stats
docker stats docs-ui-production

# Resource usage
docker-compose top

# Health check status
docker-compose ps docs-ui-prod
```

### Log Analysis

```bash
# Analyze nginx logs
docker-compose exec docs-ui-prod grep "404" /var/log/nginx/access.log

# Monitor response times
docker-compose exec docs-ui-prod awk '{print $10}' /var/log/nginx/access.log | sort -n
```

## Security Considerations

### Container Security

- **Non-root user**: Nginx runs as nginx user
- **Minimal base image**: Alpine Linux for smaller attack surface
- **No unnecessary packages**: Production image only contains required files
- **Security headers**: Comprehensive HTTP security headers

### Network Security

```bash
# Use custom networks
docker network create docs-network

# Isolate containers
docker-compose up -d --remove-orphans
```

### Updates and Maintenance

```bash
# Update base images
docker-compose pull
docker-compose up -d docs-ui-prod

# Security scanning
docker scan docs-ui:latest
```

## Scaling and High Availability

### Load Balancing

```yaml
# docker-compose.override.yml
services:
  docs-ui-prod:
    deploy:
      replicas: 3
    labels:
      - "traefik.http.services.docs-ui.loadbalancer.server.port=80"
```

### Health Checks

The production service includes comprehensive health monitoring:

- **HTTP health endpoint**: `/health`
- **Container health checks**: Built into Docker
- **Monitoring integration**: Ready for Prometheus/Grafana

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]
    
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build and push
        run: |
          docker build -t docs-ui:${{ github.sha }} .
          docker push docs-ui:${{ github.sha }}
```

### GitLab CI

```yaml
# .gitlab-ci.yml
stages:
  - build
  - deploy

build:
  stage: build
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

## Support

For additional help with Docker deployment:

1. Check the [Troubleshooting Guide](/troubleshooting)
2. Review [Getting Started](/getting-started) for basic setup
3. Consult the [API Reference](/api-reference) for configuration options
4. Visit the Docker documentation: https://docs.docker.com

## Next Steps

- Set up monitoring with Prometheus and Grafana
- Configure automatic backups
- Implement blue-green deployment
- Add CDN integration for global performance

Ready to deploy? Start with `docker-compose up -d docs-ui-prod` and your documentation site will be live! 