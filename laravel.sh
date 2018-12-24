#!/bin/bash

composer install
php artisan key:generate

mlock="/app/migrate.lock"
if [ ! -f $mlock ]; then
	touch $mlock
	php artisan migrate --seed
fi
