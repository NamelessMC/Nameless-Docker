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
    -t namelessmc/nginx:v2-pr9 \
    -t namelessmc/nginx:v2-pr9-php8 \
    -t namelessmc/nginx:v2-pr10 \
    -t namelessmc/nginx:v2-pr10-php74 \
    -t namelessmc/nginx:v2-pr11 \
    -t namelessmc/nginx:v2-pr11-php74 \
    -t namelessmc/nginx:v2-pr12 \
    -t namelessmc/nginx:v2-pr12-php74 \
    -t namelessmc/nginx:dev \
    --platform=linux/arm,linux/arm64,linux/amd64 nginx_web --push

deploy_php(){
    docker buildx build \
        -t namelessmc/php:$1 \
        --build-arg PHP_VERSION=$2 --build-arg VERSION=$3 \
        --platform=linux/amd64 php_fpm --push
}

#           Tag             PHP NamelessMC
deploy_php  v2-pr7          7.4 v2.0.0-pr7
deploy_php  v2-pr8          7.4 v2.0.0-pr8
deploy_php  v2-pr9          7.4 v2.0.0-pr9
deploy_php  v2-pr9-php8     8.0 v2.0.0-pr9
deploy_php  v2-pr10         8.0 v2.0.0-pr10
deploy_php  v2-pr10-php74   7.4 v2.0.0-pr10
deploy_php  v2-pr11         8.0 v2.0.0-pr11
deploy_php  v2-pr11-php74   7.4 v2.0.0-pr11
deploy_php  v2-pr12         8.0 v2.0.0-pr12
deploy_php  v2-pr12-php74   7.4 v2.0.0-pr12
deploy_php  dev             8.0 v2
