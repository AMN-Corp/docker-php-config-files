#!/bin/bash

# Ensure DNS resolvers are set (Docker internal DNS first, then public DNS as fallback)
printf "nameserver 127.0.0.11\nnameserver 8.8.8.8\nnameserver 1.1.1.1\n" > /etc/resolv.conf

# Verify DNS configuration
echo "DNS resolvers configured:"
cat /etc/resolv.conf

# Test DNS resolution
echo "Testing DNS resolution..."
nslookup google.com || echo "DNS test failed, but continuing..."

# Create required directories if they don't exist
mkdir -p /var/log/nginx
mkdir -p /var/log/supervisor
mkdir -p /var/www/html/storage/logs

# Set proper permissions
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache

# Start Supervisor (which will manage Nginx, PHP-FPM, and Cron)
echo "Starting Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
