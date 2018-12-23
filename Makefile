all: help

# it's important to declare we are using bash, otherwise some make commands may fail
SHELL := /bin/bash

include .env

help:
	###########################################################################################################
	# [DOCKER]
	# clean                     - [danger] remove all docker images
	# cleanup                   - [danger] stop all running containers and then remove all docker images
	# conndb                    - connect to MariaDB using root
	# connredis                 - connect to redis
	# images                    - show docker images
	# kill                      - kill container, e.g. make kill c=nginx
	# logs                      - tail the container logs, e.g. make logs c=nginx
	# network                   - create docker bridge network
	# prune                     - run docker system prune
	# prune-data                - [danger] run docker system prune and also remove container volume
	# ps                        - list all containers
	# restart                   - restart container, e.g. make restart c=nginx
	# rm-con                    - remove all dead containers (non-zero Exited)
	# rm-img                    - remove all <none> images/layers
	# sh                        - enter the container, e.g. make sh c=nginx
	# stats                     - show container stats, e.g. make stats c=nginx
	#
	# [DOCKER COMPOSE]
	# up                        - run docker-compose up (boot up all the basic services)
	# down                      - run docker-compose down (shutdown all the basic services)
	# laravel                   - boot up laravel container
	# laravel-down              - remove laravel container
	# mariadb                   - boot up mariadb container
	# mariadb-down              - remove mariadb container
	# nginx-proxy               - boot up nginx-proxy container
	# nginx-proxy-down          - remove nginx-proxy container
	# portainer                 - boot up portainer container
	# portainer-down            - remove mongo container
	# redis                     - boot up redis container
	# redis-down                - remove redis container
	# vsftpd                    - boot up vsftpd container
	# vsftpd-down               - remove vsftpd container
	#
	###########################################################################################################
	@echo "Enjoy!"

clean:
	docker rmi -f $(docker images -q)

cleanup: kill clean

conndb:
	docker run -it --rm --network=${NETWORK} ${MARIADB_IMG} bash -c "mysql -A --default-character-set=utf8 -h${MARIADB_NAME} -uroot -p${MARIADB_PASSWORD}"

connredis:
	docker run --rm -it --net=${NETWORK} ${REDIS_IMG} redis-cli -h ${REDIS_NAME}

images:
	docker images

kill:
	@if [ "$$c" == "" ]; then c=$$(docker ps -q); fi; \
	docker kill $$c

logs:
	@docker logs -f $$c

network:
	docker network create -d bridge ${NETWORK} || true

print:
	@printf '\x1B[32m%s\x1B[0m\n' "$$m"

prune:
	@docker system prune -f

prune-data:
	@docker system prune -f --volumes

ps:
	docker ps -a

restart:
	@if [ "$$c" == "" ]; then c=$$(docker ps -a | sed 1d | awk '{print $$NF}'); fi; \
	docker restart $$c

rm-con:
	deads=$$(docker ps -a | sed 1d | grep "Exited " | grep -v "Exited (0)" | awk '{print $$1}'); if [ "$$deads" != "" ]; then docker rm -f $$deads; fi

rm-img: rm-con
	none=$$(docker images | sed 1d | grep "^<none>" | awk '{print $$3}'); if [ "$$none" != "" ]; then docker rmi $$none; fi

sh:
	@docker exec -it $$c bash

stats:
	@if [ "$$c" == "" ]; then c=$$(docker ps -a | sed 1d | awk '{print $$NF}'); fi; \
	docker stats $$c


#####   ####   ####  #    # ###### #####       ####   ####  #    # #####   ####   ####  ######
#    # #    # #    # #   #  #      #    #     #    # #    # ##  ## #    # #    # #      #
#    # #    # #      ####   #####  #    #     #      #    # # ## # #    # #    #  ####  #####
#    # #    # #      #  #   #      #####      #      #    # #    # #####  #    #      # #
#    # #    # #    # #   #  #      #   #      #    # #    # #    # #      #    # #    # #
#####   ####   ####  #    # ###### #    #      ####   ####  #    # #       ####   ####  ######

up: network
	docker-compose up -d

down:
	docker-compose down

laravel: mariadb nginx-proxy redis
	docker run -it --rm --network=${NETWORK} -v "${PWD}/laravel.sql:/laravel.sql" ${MARIADB_IMG} \
	bash -c "mysql -A -h${MARIADB_NAME} -uroot -p${MARIADB_PASSWORD} < /laravel.sql"
	git submodule update --init
	docker-compose -f docker-compose-laravel.yml up -d laravel

laravel-down:
	docker-compose -f docker-compose-laravel.yml rm -fs laravel

mariadb: network
	docker-compose up -d mariadb

mariadb-down:
	docker-compose rm -fs mariadb

nginx-proxy: network
	docker-compose up -d nginx-proxy

nginx-proxy-down:
	docker-compose rm -fs nginx-proxy

portainer: network
	docker-compose -f docker-compose-portainer.yml up -d portainer

portainer-down:
	docker-compose -f docker-compose-portainer.yml rm -fs portainer

redis: network
	docker-compose up -d redis

redis-down:
	docker-compose rm -fs redis

vsftpd: network
	docker-compose -f docker-compose-vsftpd.yml up -d vsftpd

vsftpd-down:
	docker-compose -f docker-compose-vsftpd.yml rm -fs vsftpd
