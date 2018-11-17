.PHONY: up-database up-all \ 
		up-hazelcast down up-consul \ 
		up-consul-clients up-vault \
		down status

up-all: up-database up-hazelcast up-consul up-vault

up-vault: up-consul
	@echo up vault
	@docker-compose up -d vault-server-0

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
	@docker exec `docker ps -q --filter "name=database-node-1_1"` mysql -e "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size';" | grep -Eo '[0-9]*' | xargs echo Maria cluster size: 