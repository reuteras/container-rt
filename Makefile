all: up

up:
	docker compose up

dev-up:
	docker compose -f docker-compose-devel.yml -p container-rt-dev up

dev-clean:
	docker compose -f docker-compose-devel.yml -p container-rt-dev stop 
	docker compose -f docker-compose-devel.yml -p container-rt-dev rm --force
	docker volume rm container-rt-dev_db container-rt-dev_app

dev-build: build
build:
	docker build --tag=docker-rt-test rt

dev-no-cache-build: no-cache-build
no-cache-build:
	docker build --tag=docker-rt-test --no-cache rt
