#!/bin/bash
set -e
docker run --rm --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d
export DOCKER_CLI_EXPERIMENTAL=enabled
set +e
docker buildx rm namelessmc_builder
set -e
docker buildx create --use --name namelessmc_builder
docker buildx build -t namelessmc-nginx --platform=linux/arm,linux/arm64,linux/amd64 nginx_web --push
docker buildx build -t namelessmc-php --platform=linux/arm,linux/arm64,linux/amd64 php_fpm --push
docker buildx rm namelessmc_builder
