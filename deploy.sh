#!/bin/bash

# Before running this, you need to install binfmt_misc support and create a builder:
# docker run --privileged --rm tonistiigi/binfmt --install all
# export DOCKER_CLI_EXPERIMENTAL=enabled
# docker buildx create --use --name mybuilder
# https://github.com/docker/buildx
set -e

export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx build -t namelessmc/nginx --platform=linux/arm,linux/arm64,linux/amd64 nginx_web --push
docker buildx build -t namelessmc/php --platform=linux/arm,linux/arm64,linux/amd64 php_fpm --push
docker buildx build -t namelessmc/php:dev --build-arg VERSION=v2 --platform=linux/arm,linux/arm64,linux/amd64 php_fpm --push
