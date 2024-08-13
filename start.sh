#!/bin/sh

echo "Running service..."
exec /usr/bin/supervisord -n -c /supervisord.conf