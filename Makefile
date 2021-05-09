all: up

up:
	docker-compose up -d

down:
	docker-compose down

rm:
	docker-compose rm

pull:
	docker pull reuteras/container-rt

clean:
	docker-compose stop
	docker-compose rm --force
	docker volume rm container-rt_db container-rt_app || true

database-upgrade:
	docker-compose exec -T --user rt-service --workdir /opt/rt5 rt /opt/rt5/sbin/rt-setup-database --action upgrade

build:
	docker build --tag=docker-rt-test rt

no-cache-build:
	docker build --tag=docker-rt-test --no-cache rt

image-rm:
	docker rmi docker-rt-test

dist-clean: down rm clean image-rm
