ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-fpm

RUN BUILD_DEPS="libmcrypt-dev libldap2-dev" && \
    RUNTIME_DEPS="libjpeg62-turbo-dev libfreetype6-dev libpng-dev libfreetype6-dev curl tar sendmail" && \
    apt-get update && \
    apt-get install -y --no-install-recommends $BUILD_DEPS $RUNTIME_DEPS && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j "$(nproc)" exif gd pdo_mysql mysqli && \
    apt-get purge -y $BUILD_DEPS && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

RUN { \
        echo "upload_max_filesize = 512M"; \
        echo "post_max_size = 512M"; \
        echo "max_input_time = 300"; \
        echo "max_execution_time = 300"; \
    } > /usr/local/etc/php/conf.d/nameless.ini

RUN { \
        echo "[www]"; \
        echo "pm.max_children = 32"; \
        echo "pm.start_servers = 1"; \
        echo "pm.min_spare_servers = 1"; \
        echo "pm.max_spare_servers = 4" ; \
    } > /usr/local/etc/php-fpm.d/zz-nameless.conf

ADD entrypoint.sh /

ARG VERSION=v2.0.0-pr10
ENV VERSION=${VERSION}

# Used by website to know if it runs using our docker images for statistics
ENV NAMELESSMC_METRICS_DOCKER=true

# Hide path option in the installer, subdirectories are not compatible with the nginx configuration
ENV NAMELESS_PATH_HIDE=true

# Enable friendly URLs and hide the option by default, they work fine with the included configuration and there is no reason to turn it off.
ENV NAMELESS_FRIENDLY_URLS=true NAMELESS_FRIENDLY_URLS_HIDE=true

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
