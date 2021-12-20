#!/bin/sh

if [ -n "$(getent group "$WWW_DATA_GID")" ]
then
    GROUPNAME=$(getent passwd "$WWW_DATA_GID" | cut -d: -f1)
    echo "Deleting group $GROUPNAME which already uses GID $WWW_DATA_GID"
    groupdel "$GROUPNAME"
else
    echo "GID $WWW_DATA_GID not in use"
fi

if [ -n "$(getent passwd "$WWW_DATA_UID")" ]
then
    USERNAME=$(getent passwd "$WWW_DATA_UID" | cut -d: -f1)
    echo "Deleting user $USERNAME which already uses UID $WWW_DATA_UID"
    userdel "$USERNAME"
else
    echo "UID $WWW_DATA_UID not in use"
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

cat > /etc/nginx/php.conf << EOL
upstream php-handler {
    server ${PHP_FPM};
}
EOL

exec nginx -g "daemon off;"
