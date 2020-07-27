#!/bin/sh
docker build -t namelessmc-nginx nginx_web
docker build -t namelessmc-php php_fpm
