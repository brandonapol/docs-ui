worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    access_log /var/log/nginx/access.log main;

    # Basic settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 16M;
    
    # Hide nginx version
    server_tokens off;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    server {
        listen 80;
        server_name _;
        root /usr/share/nginx/html;
        index index.html;

        # Security headers specific to this server
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

        # Handle static assets with caching
        location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
            add_header Vary Accept-Encoding;
            access_log off;
        }

        # Handle HTML files with short cache
        location ~* \.html$ {
            expires 1h;
            add_header Cache-Control "public, max-age=3600";
            add_header Vary Accept-Encoding;
        }

        # Handle API routes (if any)
        location /api/ {
            expires -1;
            add_header Cache-Control "no-store, no-cache, must-revalidate";
        }

        # Main location block for SPA routing
        location / {
            try_files $uri $uri/ $uri.html /index.html;
            
            # Cache control for routes
            expires 1h;
            add_header Cache-Control "public, max-age=3600";
        }

        # Handle specific Nuxt.js routes
        location /_nuxt/ {
            expires 1y;
            add_header Cache-Control "public, immutable";
            access_log off;
        }

        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }

        # Deny access to hidden files
        location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
        }

        # Deny access to backup files
        location ~ ~$ {
            deny all;
            access_log off;
            log_not_found off;
        }

        # Handle 404 errors
        error_page 404 /404.html;
        location = /404.html {
            root /usr/share/nginx/html;
            internal;
        }

        # Handle 50x errors
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root /usr/share/nginx/html;
            internal;
        }
    }
} 