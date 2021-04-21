all: up

up:
	docker compose up -d

down:
	docker compose down

rm:
	docker compose rm

dev-up:
	docker compose -f docker-compose-devel.yml -p container-rt-dev up

clean:
	docker compose stop
	docker compose rm --force
	docker volume rm container-rt_db container-rt_app || true

dev-up-daemon:
	docker compose -f docker-compose-devel.yml -p container-rt-dev up -d

dev-down:
	docker compose -f docker-compose-devel.yml -p container-rt-dev down

dev-rm:
	docker compose -f docker-compose-devel.yml -p container-rt-dev rm --force

dev-clean:
	docker compose -f docker-compose-devel.yml -p container-rt-dev stop 
	docker compose -f docker-compose-devel.yml -p container-rt-dev rm --force
	docker volume rm container-rt-dev_db container-rt-dev_app || true

dev-database-upgrade:
	docker compose -f docker-compose-devel.yml -p container-rt-dev exec -T --user rt-service --workdir /opt/rt5 rt /opt/rt5/sbin/rt-setup-database --action upgrade

dev-build: build
build:
	docker build --tag=docker-rt-test rt

dev-no-cache-build: no-cache-build
no-cache-build:
	docker build --tag=docker-rt-test --no-cache rt

image-rm:
	docker rmi docker-rt-test

dist-clean: down rm clean dev-down dev-rm dev-clean image-rm
