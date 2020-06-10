#!/bin/sh
docker build -t derkades/namelessmc-nginx nginx_web
docker build -t derkades/namelessmc-php   php_fpm
