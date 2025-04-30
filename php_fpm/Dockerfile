ARG PHP_IMAGE=php:8.2-fpm
FROM $PHP_IMAGE

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd pdo_mysql mysqli zip exif intl

# php-fpm loads configuration in alphabetical order so prefix with zz-
RUN { \
        echo "upload_max_filesize = 512M"; \
        echo "post_max_size = 512M"; \
        echo "max_input_time = 300"; \
        echo "max_execution_time = 300"; \
    } > /usr/local/etc/php/conf.d/zz-nameless.ini
# We want to add some additional configuration at runtime, but the entrypoint script doesn't run as root and only has
# permission to write to /tmp. So, we create a symlink that doesn't exist yet but will before php-fpm is started.
# This shouldn't allow arbritrary config modifications even though /tmp is publicly writable: a container restart is
# required to load new configuration and restarting the container overwrites this config file.
# A bit weird, I know, but it's the best I could come up with. Suggestions welcome!
RUN ln -s /tmp/additional-php-fpm-settings.conf /usr/local/etc/php-fpm.d/zz-nameless.conf

ADD entrypoint.sh /

# Used by website to know if it runs using our docker images for statistics
ENV NAMELESSMC_METRICS_DOCKER=true

# Hide path option in the installer, subdirectories are not compatible with the nginx configuration
ENV NAMELESS_PATH_HIDE=true

# Enable friendly URLs and hide the option by default, they work fine with the included configuration and there is no reason to turn it off.
ENV NAMELESS_FRIENDLY_URLS=true NAMELESS_FRIENDLY_URLS_HIDE=true

ARG NAMELESS_DOWNLOAD_VERSION=ERROR_NOT_SPECIFIED
ENV NAMELESS_DOWNLOAD_VERSION=$NAMELESS_DOWNLOAD_VERSION

ENV PHP_PM="ondemand" \
    PHP_PM_MAX_CHILDREN="16" \
    PHP_PM_MAX_REQUESTS="200" \
    PHP_PM_IDLE_TIMEOUT="1m" \
    PHP_PM_MIN_SPARE_SERVERS="2" \
    PHP_PM_MAX_SPARE_SERVERS="4"

RUN mkdir /data && \
    chown 33:33 /data
WORKDIR /data

# The www-data user has uid 33 on Debian/Ubuntu which is what most people are used to
USER 33

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
