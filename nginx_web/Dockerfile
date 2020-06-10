FROM nginx:alpine

ENV PHP_FPM="namelessmc_php:9000"

RUN deluser xfs && \
    delgroup www-data && \
    adduser -DH -h /home/www-data -s /sbin/nologin -u 33 www-data

RUN find /etc/nginx -type f -not -name 'mime.types' -not -name 'fastcgi_params' -delete && \
    rm -rf conf.d modules

COPY nginx.conf /etc/nginx
COPY entrypoint.sh /

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
