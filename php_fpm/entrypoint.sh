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
    echo "Data directory is empty, downloading NamelessMC.."
    set -x
    mkdir -p /data
    cd /tmp
    curl -Lo "nameless.tar.gz" "https://github.com/NamelessMC/Nameless/archive/${VERSION}.tar.gz"
    tar -xf "nameless.tar.gz"
    mv Nameless-*/* "/data"
    rm -rf /tmp/*
    # remove some unnecessary files (dotfiles in the root directory are not copied in the first place)
    cd /data
    rm -rf \
        cache/.htaccess \
        changelog.txt \
        CONTRIBUTORS.md \
        docker-compose.yaml \
        Dockerfile \
        nginx.example \
        README.md \
        web.config.example \
        uploads/placeholder.txt \
        LICENSE.txt \
        SECURITY.md \
        phpstan.neon
    # fix permissions
    # chown -R www-data:www-data /data
    find . -type d -exec chmod 750 {} \;
    find . -type f -exec chmod 640 {} \;
    set +x
    echo "Done!"
fi

if [ -n "$NAMELESS_AUTO_INSTALL" ]
then
    echo "NAMELESS_AUTO_INSTALL is only supported from pr13"
    exit 1
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
