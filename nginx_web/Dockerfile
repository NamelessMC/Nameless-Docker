FROM nginx:alpine

ENV PHP_FPM="php:9000"

ENV WWW_DATA_UID=33 WWW_DATA_GID=33

RUN apk add --no-cache shadow

RUN find /etc/nginx -type f -not -name 'mime.types' -not -name 'fastcgi_params' -delete && \
    rm -rf conf.d modules

COPY nginx.conf /etc/nginx
COPY entrypoint.sh /

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
