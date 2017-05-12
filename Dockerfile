FROM php:7.0-apache

ARG NAMELESSMC_VERSION=1.0.16

WORKDIR /var/www

RUN docker-php-source extract \
    && apt-get update \
    && apt-get install libmcrypt-dev libldap2-dev nano libpng12-dev libjpeg62-turbo-dev libfreetype6-dev curl tar -y \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd mcrypt \
    && a2enmod rewrite \
    && docker-php-source delete \
    && curl -Lo nameless.tar.gz https://github.com/NamelessMC/Nameless/archive/v$NAMELESSMC_VERSION.tar.gz \
    && tar -xvf nameless.tar.gz \
    && mv Nameless-$NAMELESSMC_VERSION/* /var/www/html/ \
    && bash -c "mv Nameless-$NAMELESSMC_VERSION/.[^.]* /var/www/html/" \
    && rm -rf nameless.tar.gz Nameless-$NAMELESSMC_VERSION \ 
    && chown -R www-data:www-data /var/www/html \
    && chmod 755 -R /var/www/html \
    && apt-get clean \ 
    && apt-get autoclean \ 
    && apt-get autoremove --purge -y \ 
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*
