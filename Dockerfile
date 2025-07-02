# Multi-stage build for Nuxt.js application

# Stage 1: Build the application
FROM --platform=linux/amd64 node:20-slim AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies for production build
RUN npm ci --no-fund --omit=dev

# Copy source code
COPY . .

# Build the application for static generation (production mode)
RUN npm run build

# Stage 2: Production server with nginx
FROM --platform=linux/amd64 nginx:1.25-alpine AS production

# Install bash and curl for debugging and health checks
RUN apk add --no-cache bash curl

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy built application from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Create nginx cache directories
RUN mkdir -p /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp

# Set proper permissions
RUN chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /usr/share/nginx/html \
    && chown -R nginx:nginx /var/log/nginx

# Create a non-root user for nginx
RUN addgroup -g 1001 -S nodejs \
    && adduser -S nextjs -u 1001 -G nodejs

# Switch to non-root user
USER nginx

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 