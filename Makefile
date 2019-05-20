.PHONY: all
all: help

# it's important to declare we are using bash, otherwise some make commands may fail
SHELL := /bin/bash

include .env

.PHONY: help
help:
	###########################################################################################################
	# [DOCKER]
	# clean                     - [danger] remove all docker images
	# cleanup                   - [danger] stop all running containers and then remove all docker images
	# conndb                    - connect to MariaDB using root
	# connmysql                 - connect to MySQL using root
	# connredis                 - connect to redis
	# images                    - show docker images
	# kill                      - kill container, e.g. make kill c=nginx
	# logs                      - tail the container logs, e.g. make logs c=nginx
	# network                   - create docker bridge network
	# pingdb                    - check mariadb health
	# pingmysql                 - check mysql health
	# prune                     - run docker system prune
	# prune-data                - [danger] run docker system prune and also remove container volume
	# ps                        - list all containers
	# restart                   - restart container, e.g. make restart c=nginx
	# rm-con                    - remove all dead containers (non-zero Exited)
	# rm-img                    - remove all <none> images/layers
	# sh                        - enter the container, e.g. make sh c=nginx
	# stats                     - show container stats, e.g. make stats c=nginx
	# vault-cli                 - execute vault commands, e.g. make vault-cli c="kv get secret/hello"
	#
	# [SERVICES]
	# up                        - boot up basic services
	# down                      - remove basic services
	# jaeger                    - boot up jaeger container
	# jaeger-down               - remove jaeger container
	# laravel                   - boot up laravel container
	# laravel-down              - remove laravel container
	# mariadb                   - boot up mariadb container
	# mariadb-down              - remove mariadb container
	# mongo                     - boot up mongodb container
	# mongo-down                - remove mongodb container
	# mysql                     - boot up mysql container
	# mysql-down                - remove mysql container
	# nginx-proxy               - boot up nginx-proxy container
	# nginx-proxy-down          - remove nginx-proxy container
	# phpmyadmin                - boot up phpmyadmin container
	# phpmyadmin-down           - remove phpmyadmin container
	# portainer                 - boot up portainer container
	# portainer-down            - remove mongo container
	# redis                     - boot up redis container
	# redis-down                - remove redis container
	# vault                     - boot up vault container
	# vault-down                - remove vault container
	# vsftpd                    - boot up vsftpd container
	# vsftpd-down               - remove vsftpd container
	#
	###########################################################################################################
	@echo "Enjoy!"

.PHONY: clean
clean:
	docker rmi -f $(docker images -q)

.PHONY: cleanup
cleanup: kill clean

.PHONY: conndb
conndb:
	docker-compose -f docker-compose-mariadb.yml run --rm ${MARIADB_NAME} bash -c "mysql -A --default-character-set=utf8 -h${MARIADB_NAME} -uroot"

.PHONY: connmysql
connmysql:
	docker-compose -f docker-compose-mysql.yml run --rm ${MYSQL_NAME} bash -c "mysql -A --default-character-set=utf8 -h${MYSQL_NAME} -uroot"

.PHONY: connredis
connredis:
	docker run --rm -it --network=${NETWORK} ${REDIS_IMG} redis-cli -h ${REDIS_NAME}

.PHONY: images
images:
	docker images

.PHONY: kill
kill:
	@if [ "$$c" == "" ]; then c=$$(docker ps -q); fi; \
	docker kill $$c

.PHONY: logs
logs:
	@docker logs -f $$c

.PHONY: network
network:
	docker network create -d bridge ${NETWORK} || true

.PHONY: pingdb
pingdb:
	@n=1; \
	while [ $${n} -eq 1 ]; \
	do \
		sleep 2s; \
		docker exec -it ${MARIADB_NAME} bash -c "mysql -u root -h 127.0.0.1 -p${MARIADB_PASSWORD} -e 'SELECT 1;'"; \
		n=$$?; \
	done;
	@make print m="mariadb is ready for use";

.PHONY: pingmysql
pingmysql:
	@n=1; \
	while [ $${n} -eq 1 ]; \
	do \
		sleep 2s; \
		docker exec -it -e MYSQL_PWD=${MYSQL_PASSWORD} ${MYSQL_NAME} bash -c "mysql -u root -h 127.0.0.1 -e 'SELECT 1;'"; \
		n=$$?; \
	done;
	@make print m="mysql is ready for use";

.PHONY: print
print:
	@printf '\x1B[32m%s\x1B[0m\n' "$$m"

.PHONY: prune
prune:
	@docker system prune -f

.PHONY: prune-data
prune-data:
	@docker system prune -f --volumes

.PHONY: ps
ps:
	docker ps -a

.PHONY: restart
restart:
	@if [ "$$c" == "" ]; then c=$$(docker ps -a | sed 1d | awk '{print $$NF}'); fi; \
	docker restart $$c

.PHONY: rm-con
rm-con:
	deads=$$(docker ps -a | sed 1d | grep "Exited " | grep -v "Exited (0)" | awk '{print $$1}'); if [ "$$deads" != "" ]; then docker rm -f $$deads; fi

.PHONY: rm-img
rm-img: rm-con
	none=$$(docker images | sed 1d | grep "^<none>" | awk '{print $$3}'); if [ "$$none" != "" ]; then docker rmi $$none; fi

.PHONY: sh
sh:
	@docker exec -it $$c sh

.PHONY: stats
stats:
	@if [ "$$c" == "" ]; then c=$$(docker ps -a | sed 1d | awk '{print $$NF}'); fi; \
	docker stats $$c

.PHONY: vault-cli
vault-cli:
	@if [ "$$c" == "" ]; then c=status; fi; \
	docker-compose -f docker-compose-vault.yml run --rm vault $$c

 ####  ###### #####  #    #  #   ####  ######  ####
#      #      #    # #    #  #  #    # #      #
 ####  #####  #    # #    #  #  #      #####   ####
     # #      #####  #    #  #  #      #           #
#    # #      #   #   #  #   #  #    # #      #    #
 ####  ###### #    #   ##    #   ####  ######  ####

.PHONY: up
up: network mariadb nginx-proxy phpmyadmin

.PHONY: down
down: mariadb-down nginx-proxy-down phpmyadmin-down

.PHONY: jaeger
jaeger: network
	docker-compose -f docker-compose-jaeger.yml up -d jaeger

.PHONY: jaeger-down
jaeger-down:
	docker-compose -f docker-compose-jaeger.yml stop jaeger
	docker-compose -f docker-compose-jaeger.yml rm -f jaeger

.PHONY: laravel
laravel: mariadb nginx-proxy redis
	@make pingdb
	docker run -it --rm --network=${NETWORK} -v "${PWD}/laravel.sql:/laravel.sql" ${MARIADB_IMG} \
	bash -c "mysql -A -h${MARIADB_NAME} -uroot -p${MARIADB_PASSWORD} < /laravel.sql"
	git submodule update --init
	docker-compose -f docker-compose-laravel.yml up -d laravel

.PHONY: laravel-down
laravel-down:
	docker-compose -f docker-compose-laravel.yml stop laravel
	docker-compose -f docker-compose-laravel.yml rm -f laravel

.PHONY: mariadb
mariadb: network
	docker-compose -f docker-compose-mariadb.yml up -d mariadb

.PHONY: mariadb-down
mariadb-down:
	docker-compose -f docker-compose-mariadb.yml stop mariadb
	docker-compose -f docker-compose-mariadb.yml rm -f mariadb

.PHONY: mongo
mongo:
	docker-compose -f docker-compose-mongo.yml up -d mongo

.PHONY: mongo-down
mongo-down:
	docker-compose -f docker-compose-mongo.yml stop mongo
	docker-compose -f docker-compose-mongo.yml rm -f mongo

.PHONY: mysql
mysql: network
	docker-compose -f docker-compose-mysql.yml up -d mysql

.PHONY: mysql-down
mysql-down:
	docker-compose -f docker-compose-mysql.yml stop mysql
	docker-compose -f docker-compose-mysql.yml rm -f mysql

.PHONY: nginx-proxy
nginx-proxy: network
	docker-compose -f docker-compose-nginx-proxy.yml up -d nginx-proxy

.PHONY: nginx-proxy-down
nginx-proxy-down:
	docker-compose -f docker-compose-nginx-proxy.yml stop nginx-proxy
	docker-compose -f docker-compose-nginx-proxy.yml rm -f nginx-proxy

.PHONY: phpmyadmin
phpmyadmin: mariadb
	@make pingdb
	docker-compose -f docker-compose-phpmyadmin.yml up -d phpmyadmin

.PHONY: phpmyadmin-down
phpmyadmin-down:
	docker-compose -f docker-compose-phpmyadmin.yml stop phpmyadmin
	docker-compose -f docker-compose-phpmyadmin.yml rm -f phpmyadmin

.PHONY: portainer
portainer: network
	docker-compose -f docker-compose-portainer.yml up -d portainer

.PHONY: portainer-down
portainer-down:
	docker-compose -f docker-compose-portainer.yml stop portainer
	docker-compose -f docker-compose-portainer.yml rm -f portainer

.PHONY: redis
redis: network
	docker-compose -f docker-compose-redis.yml up -d redis

.PHONY: redis-down
redis-down:
	docker-compose -f docker-compose-redis.yml stop redis
	docker-compose -f docker-compose-redis.yml rm -f redis

.PHONY: vault
vault: network
	docker-compose -f docker-compose-vault.yml up -d vault

.PHONY: vault-down
vault-down:
	docker-compose -f docker-compose-vault.yml stop vault
	docker-compose -f docker-compose-vault.yml rm -f vault

.PHONY: vsftpd
vsftpd: network
	docker-compose -f docker-compose-vsftpd.yml up -d vsftpd

.PHONY: vsftpd-down
vsftpd-down:
	docker-compose -f docker-compose-vsftpd.yml stop vsftpd
	docker-compose -f docker-compose-vsftpd.yml rm -f vsftpd
