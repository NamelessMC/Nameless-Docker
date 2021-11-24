#!/bin/sh

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

# for some reason, a www-data group exists by default but a www-data user doesn't
echo "Adding www-data user with UID $WWW_DATA_UID and setting www-data GID to $WWW_DATA_GID"
groupmod -g "$WWW_DATA_GID" www-data
adduser -D -G www-data -u "$WWW_DATA_UID" www-data

cat > /etc/nginx/php.conf << EOL
upstream php-handler {
    server ${PHP_FPM};
}
EOL

exec nginx -g "daemon off;"
