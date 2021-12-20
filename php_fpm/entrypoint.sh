#!/bin/sh
set -e

if [ -n "$(getent passwd "$WWW_DATA_UID")" ]
then
    USERNAME=$(getent passwd "$WWW_DATA_UID" | cut -d: -f1)
    echo "Deleting user $USERNAME which already uses UID $WWW_DATA_UID"
    userdel "$USERNAME"
else
    echo "UID $WWW_DATA_UID not in use"
fi

if [ -n "$(getent group "$WWW_DATA_GID")" ]
then
    GROUPNAME=$(getent passwd "$WWW_DATA_GID" | cut -d: -f1)
    echo "Deleting group $GROUPNAME which already uses GID $WWW_DATA_GID"
    groupdel "$GROUPNAME"
else
    echo "GID $WWW_DATA_GID not in use"
fi

if [ -n "$(getent group www-data)" ]
then
    echo "Modifying existing www-data group, setting GID to $WWW_DATA_GID"
    groupmod -g "$WWW_DATA_GID" www-data
else
    echo "Adding www-data group with GID $WWW_DATA_GID"
    groupadd -g "$WWW_DATA_GID" www-data
fi

if [ -n "$(getent passwd www-data)" ]
then
    echo "Modifying existing www-data user, setting GID to $WWW_DATA_GID"
    usermod -g "$WWW_DATA_GID" www-data
else
    echo "Adding www-data user with UID $WWW_DATA_UID and GID $WWW_DATA_GID"
    getent passwd 1000
    useradd -u "$WWW_DATA_UID" -g "$WWW_DATA_GID" www-data
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
    composer install
    # fix permissions
    chown -R www-data:www-data .
    find . -type d -exec chmod 750 {} \;
    find . -type f -exec chmod 640 {} \;
    set +x
    echo "Done!"
fi

if [ -n "$NAMELESS_AUTO_INSTALL" ]
then
    cd /data
    if [ -f core/config.php ]; then
        echo "core/config.php exists, not running installer."
    else
        echo "Going to run installer, first waiting 10 seconds for the database to start"
        sleep 10
        echo "Running installer..."
        php -f cli_install.php -- --iSwearIKnowWhatImDoing
    fi
fi

exec php-fpm
