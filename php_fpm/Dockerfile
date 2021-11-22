ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-fpm-alpine

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd pdo_mysql mysqli zip exif

# Set www-data user and group to id 33 which is standard in Debian
RUN deluser xfs && \
    apk add --no-cache shadow && \
    usermod -u 33 www-data && \
    groupmod -g 33 www-data && \
    apk del shadow

RUN { \
        echo "upload_max_filesize = 512M"; \
        echo "post_max_size = 512M"; \
        echo "max_input_time = 300"; \
        echo "max_execution_time = 300"; \
    } > /usr/local/etc/php/conf.d/nameless.ini && \
    { \
        echo "[www]"; \
        echo "pm.max_children = 32"; \
        echo "pm.start_servers = 1"; \
        echo "pm.min_spare_servers = 1"; \
        echo "pm.max_spare_servers = 4" ; \
    } > /usr/local/etc/php-fpm.d/zz-nameless.conf

ADD entrypoint.sh /

ARG VERSION=v2.0.0-pr12
ENV VERSION=${VERSION}

# Used by website to know if it runs using our docker images for statistics
ENV NAMELESSMC_METRICS_DOCKER=true

# Hide path option in the installer, subdirectories are not compatible with the nginx configuration
ENV NAMELESS_PATH_HIDE=true

# Enable friendly URLs and hide the option by default, they work fine with the included configuration and there is no reason to turn it off.
ENV NAMELESS_FRIENDLY_URLS=true NAMELESS_FRIENDLY_URLS_HIDE=true

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
