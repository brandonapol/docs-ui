# DigitalOcean-specific Dockerfile with port 80 configuration
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
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy custom nginx configuration for DigitalOcean (port 80)
COPY nginx.conf.do /etc/nginx/nginx.conf

# Copy built application
COPY --from=builder /app/.output/public /usr/share/nginx/html

# Expose port 80 for DigitalOcean
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 