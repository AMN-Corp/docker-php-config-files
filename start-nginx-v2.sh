#!/bin/bash

# Ensure DNS resolvers are set (Docker internal DNS first, then public DNS as fallback)
printf "nameserver 127.0.0.11\nnameserver 8.8.8.8\nnameserver 1.1.1.1\n" > /etc/resolv.conf

# Verify DNS configuration
echo "DNS resolvers configured:"
cat /etc/resolv.conf

# Test DNS resolution
echo "Testing DNS resolution..."
nslookup google.com || echo "DNS test failed, but continuing..."
echo ""

# Create required directories if they don't exist
echo "Creating required directories..."
mkdir -p /var/log/nginx
mkdir -p /var/log/supervisor
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/storage/framework/cache
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views

# Set proper permissions
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage 2>/dev/null || true
chown -R www-data:www-data /var/www/html/bootstrap/cache 2>/dev/null || true
chmod -R 755 /var/www/html/storage 2>/dev/null || true
chmod -R 755 /var/www/html/bootstrap/cache 2>/dev/null || true

# Check if Laravel Horizon is installed
echo ""
echo "Checking Laravel Horizon..."
if php /var/www/html/artisan list 2>/dev/null | grep -q "horizon"; then
    echo "✅ Laravel Horizon detected - will be started by Supervisor"
else
    echo "⚠️  Laravel Horizon not found - Supervisor may fail to start horizon service"
fi
echo ""

# Start Supervisor (which will manage Nginx, PHP-FPM, Cron, and Horizon)
echo "Starting Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
