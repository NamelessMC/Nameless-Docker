#!/bin/bash

# Before running this, you need to install binfmt_misc support and create a builder:
# docker run --privileged --rm tonistiigi/binfmt --install all
# export DOCKER_CLI_EXPERIMENTAL=enabled
# docker buildx create --use --name mybuilder
# https://github.com/docker/buildx
set -e

export DOCKER_CLI_EXPERIMENTAL=enabled

docker buildx build \
        -t namelessmc/nginx:v2-pr7 \
        -t namelessmc/nginx:v2-pr8 \
        -t namelessmc/nginx:v2-pr9dev \
        --platform=linux/arm,linux/arm64,linux/amd64 nginx_web --push

deploy_php(){
    docker buildx build \
            -t namelessmc/php:$1 \
            --build-arg PHP_VERSION=$2 --build-arg VERSION=$3 \
            --platform=linux/arm,linux/arm64,linux/amd64 php_fpm --push
}

#           Tag             PHP NamelessMC
deploy_php  v2-pr7          7.4 v2.0.0-pr7
deploy_php  v2-pr8          7.4 v2.0.0-pr8
deploy_php  v2-pr9dev       7.4 v2
deploy_php  v2-pr9dev-php8  8.0 v2
