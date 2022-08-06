#!/bin/sh
set -e

if [ -z "$(find /data -user "$(id -u)" -print -prune -o -prune)" ]; then
    echo "/data is not owned by the correct user, we are uid $(id -u)"
    exit 1
fi

if [ -n "$(ls -A /data 2>/dev/null)" ]
then
    echo "Data directory contains files, not downloading NamelessMC"
else
    echo "Data directory is empty, downloading NamelessMC..."
    set -x
    mkdir -p /data
    curl -L "https://github.com/NamelessMC/Nameless/releases/download/${NAMELESS_DOWNLOAD_VERSION}/nameless-deps-dist.tar.xz" | tar --xz --extract --no-same-owner --no-same-permissions --touch --directory=/data --file -
    cd /data
    # Remove some unnecessary files
    rm -rf \
        .htaccess \
        LICENSE.txt \
        cache/.htaccess \
        uploads/placeholder.txt
    chmod -R ugo-x,u+rwX,go-rw . # Files 600 directories 700
    set +x
    echo "Done!"
fi

if [ -n "$NAMELESS_AUTO_INSTALL" ]
then
    if [ -f core/config.php ]; then
        echo "core/config.php exists, not running installer."
    elif [ ! -f scripts/cli_install.php ]; then
        echo "CLI install script doesn't exist, not running installer."
    else
        echo "Running installer..."
        php -f scripts/cli_install.php -- --iSwearIKnowWhatImDoing
    fi
fi

{ \
    echo "[www]"
    echo "pm = $PHP_PM"
    echo "pm.max_children = $PHP_PM_MAX_CHILDREN"
    echo "pm.max_requests = $PHP_PM_MAX_REQUESTS"
    echo "pm.process_idle_timeout = $PHP_PM_IDLE_TIMEOUT"
    echo "pm.start_servers = $PHP_PM_MIN_SPARE_SERVERS"
    echo "pm.min_spare_servers = $PHP_PM_MIN_SPARE_SERVERS"
    echo "pm.max_spare_servers = $PHP_PM_MAX_SPARE_SERVERS"
} > /tmp/additional-php-fpm-settings.conf # this file is symlinked to the correct php-fpm configuration dir

exec php-fpm
