#!/bin/sh

if [ -z "$(find /data -user "$(id -u)" -print -prune -o -prune)" ]; then
    echo "/data is not owned by the correct user, we are uid $(id -u)"
    exit 1
fi

cat > /tmp/fastcgi-pass.conf << EOL
set \$upstream "${PHP_FPM}";
fastcgi_pass \$upstream;
EOL

exec nginx -g "daemon off;"
