# Bootup

[![Release](https://img.shields.io/github/release/dakalab/bootup.svg)](https://github.com/dakalab/bootup/releases)
[![License](https://img.shields.io/github/license/dakalab/bootup.svg)](https://github.com/dakalab/bootup)

Use docker to boot up services, nginx-proxy/mysql/redis etc. The aim of this project is to facilitate local development and testing, and demonstrate how to run famous services in container. DO NOT use it in production environment directly.

## Prerequisites

This project uses compose format version 3.7 which requires Docker Engine 18.06.0+ and docker-compose 1.22.0+.

## Getting started

All environment variables are defined in `.env`, make sure to change them to your own before booting up services.

If you just want to run in local machine for test purpose, no need to make any change.

If you want to change ports for exposing, you need to modify corresponding docker-compose files.

Before you boot up services, you need to pull git submodules:

```
make init
```

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

## Adminer

Boot up adminer:

- add `127.0.0.1 adminer.local` to `/etc/hosts`
- run `make adminer`
- visit `http://adminer.local/`

## Grafana

Boot up grafana:

- add `127.0.0.1 grafana.local` to `/etc/hosts`
- run `make grafana`
- visit `http://grafana.local`

Recommended dashboards:

- https://grafana.com/grafana/dashboards/9965
- https://grafana.com/grafana/dashboards/7362
- https://grafana.com/grafana/dashboards/893
- https://grafana.com/grafana/dashboards/1471
- https://grafana.com/grafana/dashboards/7249

## Jaeger

Boot up jaeger:

- add `127.0.0.1 jaeger.local` to `/etc/hosts`
- run `make jaeger`
- visit `http://jaeger.local/`

## kibana

Boot up kibana:

- add `127.0.0.1 kibana.local` to `/etc/hosts`
- run `make kibana`
- visit `http://kibana.local`

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

## Components

- adminer v4.7
- elasticsearch v7.3.0
- etcd v3.3.14
- geth v1.9.7
- filebeat v7.3.0
- grafana v6.3.3
- influxdb v1.7
- jaeger v1.13
- kibana v7.3.0
- laravel v5.8
- logstash v7.3.0
- mariadb v10.4
- mongodb v4.0
- mysql v8.0
- nginx v1.17
- phpmyadmin v4.9
- portainer v1.22.0
- postgres v11.4
- prometheus v2.11
- redis v5.0
- vault v1.2.2
- vsftpd v3.0
