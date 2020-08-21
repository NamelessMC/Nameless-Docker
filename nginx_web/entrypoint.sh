#!/bin/sh

cat > /etc/nginx/php.conf << EOL
upstream php-handler {
    server ${PHP_FPM};
}
EOL

exec nginx -g "daemon off;"
