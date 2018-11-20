.PHONY: build-mariadb-image up status down

up-all: build-mariadb-image
	cd Compose\ files/ && make

build-mariadb-image:
	cd MariaDB\ build/ && make

down:
	cd Compose\ files/ && make down

status:
	cd Compose\ files/ && make status 