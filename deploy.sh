#!/bin/bash

# Before running this, you need to install binfmt_misc support and create a builder:
# docker run --privileged --rm tonistiigi/binfmt --install all
# docker buildx create --use --name mybuilder
# https://github.com/docker/buildx
set -e

docker buildx build \
    -t namelessmc/nginx:dev \
    --platform=linux/amd64,linux/arm,linux/arm64 nginx_web --push

deploy_php(){
    docker buildx build \
        -t namelessmc/php:$1 \
        --build-arg PHP_VERSION=$2 --build-arg VERSION=$3 \
        --platform=linux/amd64,linux/arm64 php_fpm --push
}

#           Tag             PHP NamelessMC
deploy_php  dev             8.1 v2
