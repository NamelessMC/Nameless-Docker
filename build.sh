set -e

deploy() {
    ! podman manifest exists nameless-nginx || podman manifest rm nameless-nginx
    ! podman manifest exists nameless-php || podman manifest rm nameless-php

    podman manifest create nameless-nginx
    podman manifest create nameless-php

    podman build --platform=linux/arm64,linux/amd64 --manifest nameless-nginx nginx_web
    podman build --platform=linux/arm64,linux/amd64 --manifest nameless-php --build-arg "NAMELESS_DOWNLOAD_VERSION=$2" --build-arg "PHP_IMAGE=docker.io/$3" php_fpm

    podman manifest push --all nameless-nginx docker://docker.io/namelessmc/nginx:$1
    podman manifest push --all nameless-php   docker://docker.io/namelessmc/php:$1
}

#       container   nameless    php version
deploy  v2-pr13     v2.0.0-pr13 php:8.2-fpm

deploy  v2.0.0      v2.0.0	    php:8.2-fpm
deploy  v2.0.1      v2.0.1	    php:8.2-fpm
deploy  v2.0.2      v2.0.2	    php:8.2-fpm
deploy  v2.0.3      v2.0.3	    php:8.2-fpm
deploy  v2.0        v2.0.3	    php:8.2-fpm

deploy  v2.1.0      v2.1.0	    php:8.2-fpm
deploy  v2.1.1      v2.1.1	    php:8.2-fpm
deploy  v2.1.2      v2.1.2	    php:8.2-fpm
deploy  v2.1.3      v2.1.3	    php:8.2-fpm
deploy  v2.1.4      v2.1.4	    php:8.2-fpm
deploy  v2.1        v2.1.3	    php:8.2-fpm

deploy  v2.2.0      v2.2.0	    php:8.3-fpm
deploy  v2.2.1      v2.2.1	    php:8.3-fpm
deploy  v2.2.2      v2.2.2	    php:8.3-fpm
deploy  v2.2.3      v2.2.3	    php:8.3-fpm
deploy  v2.2        v2.2.4	    php:8.3-fpm

deploy  dev         develop	    php:8.5-fpm
