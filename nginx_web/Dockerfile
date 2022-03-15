FROM nginxinc/nginx-unprivileged

ENV PHP_FPM="php:9000" \
    NGINX_PORT="8080"

RUN find /etc/nginx -type f -not -name 'mime.types' -not -name 'fastcgi_params' -delete && \
    rm -rf conf.d modules

COPY nginx.conf /etc/nginx
COPY entrypoint.sh /

# The www-data user has uid 33 on Debian/Ubuntu which is what most people are used to
USER 33

ENTRYPOINT [ "sh", "/entrypoint.sh" ]
