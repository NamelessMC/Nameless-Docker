#!/bin/bash
set -e

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
    mv Nameless-*/{,.[^.]}* "/data"
    chown -R www-data:www-data /data
    chmod 755 -R /data
    rm -rf /tmp/*
    # remove some unnecessary files
    cd /data
    rm -rf \
        .gitignore \
        .github \
        .htaccess \
        cache/.htaccess \
        changelog.txt \
        CONTRIBUTORS.md \
        docker-compose.yaml \
        Dockerfile \
        nginx.example \
        README.md \
        web.config.example \
        uploads/placeholder.txt
    # fix permissions
    find . -type d -exec chmod 700 {} \;
    find . -type f -exec chmod 600 {} \;
    set +x
    echo "Done!"
fi

exec php-fpm
