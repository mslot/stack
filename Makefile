.PHONY: build-image up status down

up: build-image
	cd Compose\ files/ && make

build-mariadb-image:
	cd MariaDB\ build/ && make

down:
	cd Compose\ files/ && make down

status:
	cd Compose\ files/ && make status 