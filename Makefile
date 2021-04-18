all: up

up:
	docker compose up

dev-clean:
	docker compose stop && docker compose rm --force && docker volume rm container-rt_db container-rt_app

dev-build:
	docker build --tag=docker-rt-test .

dev-no-cache-build:
	docker build --tag=docker-rt-test --no-cache .
