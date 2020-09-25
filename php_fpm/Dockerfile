FROM php:7.4-fpm

RUN BUILD_DEPS="libmcrypt-dev libldap2-dev" && \
    RUNTIME_DEPS="libjpeg62-turbo-dev libfreetype6-dev libpng-dev libfreetype6-dev curl tar" && \
    apt-get update && \
    apt-get install -y --no-install-recommends $BUILD_DEPS $RUNTIME_DEPS && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j "$(nproc)" exif gd pdo_mysql mysqli && \
    apt-get purge -y $BUILD_DEPS && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

ADD entrypoint.sh /

ARG VERSION=v2.0.0-pr7
ENV VERSION=${VERSION}

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
