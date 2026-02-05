#!/bin/sh
set -e

if [ -z "$(find /data -user "$(id -u)" -print -prune -o -prune)" ]; then
    echo "/data is not owned by the correct user, we are uid $(id -u)"
    echo "please use chown -R to set the correct permissions"
    exit 1
fi

install_vendor() {
    echo "Running composer..."
    composer --no-cache install --no-progress --no-interaction
    echo "Running npm..."
    TEMPDIR=$(mktemp -d)
    npm ci -q --cache "$TEMPDIR"
    rm -rf "$TEMPDIR"
}

if [ -n "$(ls -A /data 2>/dev/null)" ]
then
    echo "Data directory contains files, not downloading NamelessMC"

    if [ -n "$NAMELESS_ALWAYS_INSTALL_DEPENDENCIES" ]
    then
        echo "NAMELESS_ALWAYS_INSTALL_DEPENDENCIES set; running composer and npm before starting webserver"
        install_vendor
        # When running npm after downloading, the script deletes node_modules. However, doing that here
        # would require redownloading all modules at every container start.
        # Someone setting NAMELESS_ALWAYS_INSTALL_DEPENDENCIES probably doesn't care about a bit of extra disk usage.
    fi
else
    echo "Data directory is empty, downloading NamelessMC..."
    mkdir -p /data

    if [ "$NAMELESS_DOWNLOAD_VERSION" = "develop" ];
    then
        curl -L "https://github.com/NamelessMC/Nameless/archive/$NAMELESS_DOWNLOAD_VERSION.tar.gz" | tar --gzip --extract --no-same-owner --no-same-permissions --touch --directory=/data --strip-components=1 --file -
    else
        curl -L "https://github.com/NamelessMC/Nameless/releases/download/${NAMELESS_DOWNLOAD_VERSION}/nameless-deps-dist.tar.xz" | tar --xz --extract --no-same-owner --no-same-permissions --touch --directory=/data --file -
    fi

    cd /data

    chmod -R u=rwX,g=,o= . # files 600 directories 700

    if [ "$NAMELESS_DOWNLOAD_VERSION" = "develop" ];
    then
        install_vendor
        if [ -z "$NAMELESS_ALWAYS_INSTALL_DEPENDENCIES" ];
        then
            rm -r node_modules  # assets are copied to core/assets/vendor directory, we don't need node_modules
        fi
    fi

    echo "Done!"
fi

if [ -n "$NAMELESS_AUTO_INSTALL" ]
then
    if [ -f "core/config.php" ]; then
        echo "core/config.php exists, not running installer."
    elif [ ! -f "dev/scripts/cli_install.php" ]; then
        echo "CLI install script doesn't exist, not running installer."
    else
        echo "Running installer..."
        php -f dev/scripts/cli_install.php -- --iSwearIKnowWhatImDoing
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
