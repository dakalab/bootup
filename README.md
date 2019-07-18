# Bootup

[![Release](https://img.shields.io/github/release/dakalab/bootup.svg)](https://github.com/dakalab/bootup/releases)
[![License](https://img.shields.io/github/license/dakalab/bootup.svg)](https://github.com/dakalab/bootup)

Use docker to boot up services, nginx-proxy/mysql/redis etc. The aim of this project is to facilitate local development and testing, and demonstrate how to run famous services in container. DO NOT use it in production environment directly.

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

## Grafana

Boot up grafana:

- add `127.0.0.1 grafana.local` to `/etc/hosts`
- run `make grafana`
- visit `http://grafana.local`

Recommended dashboards:

- https://grafana.com/grafana/dashboards/9965
- https://grafana.com/grafana/dashboards/7362
- https://grafana.com/grafana/dashboards/893

## Jaeger

Boot up jaeger:

- add `127.0.0.1 jaeger.local` to `/etc/hosts`
- run `make jaeger`
- visit `http://jaeger.local/`

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

## Prometheus

Boot up Prometheus:

- add `127.0.0.1 prometheus.local` to `/etc/hosts`
- edit `prometheus.yml` to customise the configs
- run `make prometheus`
- visit `http://prometheus.local`

## Vault

Boot up vault:

- add `127.0.0.1 vault.local` to `/etc/hosts`
- run `make vault`
- visit `http://vault.local/ui`

## Need help?

Just run

```
make help
```

## Component versions

- grafana v6.2.5
- jaeger v1.13
- laravel v5.8
- mariadb v10.4
- mongodb v4.0
- mysql v8.0
- nginx v1.17
- phpmyadmin v4.9
- portainer v1.21
- prometheus v2.11
- redis v5.0
- vault v1.1.3
- vsftpd v3.0
