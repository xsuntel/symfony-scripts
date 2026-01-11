#!/bin/sh
set -e

# >>>> PHP-FPM - Background
echo "[ Entrypoint ] Starting PHP..."
php-fpm -D

# >>>> Nginx   - Forground
echo "[ Entrypoint ] Starting Nginx on port 8080..."
nginx -g "daemon off;"

# >>>> Supervisor
echo "[ Entrypoint ] Starting Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
