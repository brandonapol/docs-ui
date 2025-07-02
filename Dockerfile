# Multi-environment Dockerfile
# Build stage
FROM node:20-slim AS builder

WORKDIR /app

# Copy package files
COPY package.docker.json package.json
COPY package-lock.json .
COPY .npmrc .

# Install dependencies 
RUN npm ci --omit=dev --silent

# Copy source code
COPY . .

# Copy DigitalOcean-specific config
COPY nuxt.config.docker.ts nuxt.config.ts

# Build the application
RUN npm run generate

# Production stage
FROM nginx:alpine

# Install bash and curl for health checks and scripting
RUN apk add --no-cache bash curl

# Copy both nginx configurations
COPY nginx.conf /etc/nginx/nginx.conf.local
COPY nginx.conf.do /etc/nginx/nginx.conf.do

# Copy built application
COPY --from=builder /app/.output/public /usr/share/nginx/html

# Create nginx cache directories and set permissions
RUN mkdir -p /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp \
    && chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /usr/share/nginx/html \
    && chown -R nginx:nginx /var/log/nginx

# Create startup script that chooses the right config
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'if [ "$DIGITALOCEAN" = "true" ] || [ -n "$DO_APP_PLATFORM" ] || [ -n "$APP_PLATFORM" ]; then' >> /start.sh && \
    echo '  echo "Detected DigitalOcean environment, using port 80"' >> /start.sh && \
    echo '  cp /etc/nginx/nginx.conf.do /etc/nginx/nginx.conf' >> /start.sh && \
    echo '  export PORT=80' >> /start.sh && \
    echo 'else' >> /start.sh && \
    echo '  echo "Using local environment, using port 8080"' >> /start.sh && \
    echo '  cp /etc/nginx/nginx.conf.local /etc/nginx/nginx.conf' >> /start.sh && \
    echo '  export PORT=8080' >> /start.sh && \
    echo 'fi' >> /start.sh && \
    echo 'exec nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

# Create non-root user (for local development)
RUN addgroup -g 1001 -S nodejs \
    && adduser -S nextjs -u 1001 -G nodejs

# Run as nginx user
USER nginx

# Expose both ports (the startup script will determine which to use)
EXPOSE 80 8080

# Smart health check that uses the right port
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD if [ "$DIGITALOCEAN" = "true" ] || [ -n "$DO_APP_PLATFORM" ] || [ -n "$APP_PLATFORM" ]; then \
        curl -f http://localhost:80/health || exit 1; \
    else \
        curl -f http://localhost:8080/health || exit 1; \
    fi

# Use the smart startup script
CMD ["/start.sh"] 