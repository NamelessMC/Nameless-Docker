FROM php:7.4-fpm

ARG NAMELESSMC_VERSION=2.0.0-pr7

RUN docker-php-source extract && \
    BUILD_DEPS="libmcrypt-dev libldap2-dev libjpeg62-turbo-dev libfreetype6-dev" && \
    apt-get update && \
    apt-get install -y $BUILD_DEPS libpng-dev curl tar && \
    docker-php-ext-configure gd && \
    docker-php-ext-install -j "$(nproc)" exif gd pdo_mysql mysqli && \
    docker-php-source delete && \
    apt-get purge -y $BUILD_DEPS && \
    apt-get clean && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

ADD entrypoint.sh /

ENV NAMELESSMC_VERSION=2.0.0-pr7

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
