#!/bin/bash

composer install
php artisan key:generate
php artisan migrate --seed

service php7.2-fpm start
service nginx start
