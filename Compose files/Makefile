.PHONY: up-database up-all \ 
		up-hazelcast down up-consul \ 
		up-consul-clients up-vault \
		down status add-root-rotation \
		build-bootstrap-script

up-all: up-database up-hazelcast add-root-rotation

up-vault:
	@echo up vault
	@docker-compose up -d vault-server-0

build-bootstrap-script:
	@echo building bootstrap script
	vault/scripts/build-bootstrap-script.sh

add-rotation: build-bootstrap-script
	@echo user rotation
	docker exec `docker ps -q --filter "name=vault-server-0"` mkdir -p /etc/vault/scripts
	docker cp vault/scripts/bootstrap-dev.final.sh `docker ps -q --filter "name=vault-server-0"`:/etc/vault/scripts
	@docker exec `docker ps -q --filter "name=vault-server-0"` /bin/sh /etc/vault/scripts/bootstrap-dev.final.sh
	@docker exec `docker ps -q --filter "name=vault-server-0"` rm /etc/vault/scripts/bootstrap-dev.final.sh

up-consul:
	@echo up consul servers
	docker-compose  up -d consul-server-0 consul-server-1
	sleep 30s
	@echo up consul clients
	@docker-compose up -d consul-client-0 consul-client-1

up-hazelcast:
	@echo up hazelcast
	@docker-compose up -d hazel-cast-server-0 hazel-cast-server-1

up-database:
	docker-compose up -d database-node-1
	sleep 30s
	docker-compose up -d database-node-2
	sleep 30s
	docker-compose up -d database-node-3

down:
	@echo down
	@docker-compose down

status:
	@docker exec `docker ps -q --filter "name=database-node-1_1"` mysql -uroot -ponetimepasswordeoirgj3434oijwgøorigjqw34toi34nhwoh4oin -e "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size';" | grep -Eo '[0-9]*' | xargs echo Maria cluster size: 