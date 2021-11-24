#!/bin/sh
set -e

if [ -n "$(getent passwd "$WWW_DATA_UID")" ]
then
    USERNAME=$(getent passwd "$WWW_DATA_UID" | cut -d: -f1)
    echo "Deleting user $USERNAME which already uses UID $WWW_DATA_UID"
    deluser "$USERNAME"
fi

if [ -n "$(getent group "$WWW_DATA_GID")" ]
then
    GROUPNAME=$(getent passwd "$WWW_DATA_GID" | cut -d: -f1)
    echo "Deleting group $GROUPNAME which already uses GID $WWW_DATA_GID"
    delgroup "$GROUPNAME"
fi

echo "Setting www-data uid:gid to $WWW_DATA_UID:$WWW_DATA_GID"
usermod -u "$WWW_DATA_UID" www-data
groupmod -g "$WWW_DATA_GID" www-data

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
    chown -R www-data:www-data /data
    find . -type d -exec chmod 750 {} \;
    find . -type f -exec chmod 640 {} \;
    set +x
    echo "Done!"
fi

exec php-fpm
