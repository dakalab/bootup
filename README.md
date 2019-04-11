# Bootup

[![Release](https://img.shields.io/github/release/dakalab/bootup.svg)](https://github.com/dakalab/bootup/releases)
[![License](https://img.shields.io/github/license/dakalab/bootup.svg)](https://github.com/dakalab/bootup)

Use docker to boot up services, nginx-proxy/mysql/redis etc.

## Settings

All environment variables are defined in `.env`, make sure to change them to your own before booting up services.

If you just want to run in local machine for test purpose, no need to change anyting.

If you want to change ports for exposing, you need to modify docker-compose files.

## Basic services

Boot up basic services:

```
make up
```

Boot up a specific service, e.g. `redis`:

```
make redis
```

Stop a specific service, e.g. `redis`:

```
make redis-down
```

Stop basic services:

```
make down
```

## Laravel

Boot up laravel:

- add `127.0.0.1 laravel.local` to `/etc/hosts`
- run `make laravel`
- run `make logs c=laravel` to watch the setup logs, and take a teatime to wait for initialization finish
- visit `http://laravel.local`

## phpMyAdmin

Boot up phpMyAdmin:

- add `127.0.0.1 phpmyadmin.local` to `/etc/hosts`
- run `make phpmyadmin`
- visit `http://phpmyadmin.local`

## Portainer

Boot up portainer:

- add `127.0.0.1 portainer.local` to `/etc/hosts`
- run `make portainer`
- visit `http://portainer.local`

## Need help?

Just run

```
make help
```

## Component versions

- mariadb v10.3
- nginx v1.14
- redis v5.0
- laravel v5.7
- phpmyadmin v4.8
- portainer v1.20
- vsftpd v3.0
- mongodb v4.0
