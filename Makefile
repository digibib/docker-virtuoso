.PHONY: all build

build:
	@echo "======= FORCE RECREATING image ======\n"
	docker-compose stop virtuoso && true &&\
	docker-compose rm -f virtuoso || true &&\
	docker-compose build virtuoso &&\
	docker-compose up --force-recreate --no-deps -d virtuoso

run:
	docker-compose up -d virtuoso || true

stop:
	docker-compose stop virtuoso || true

login: 				## Log in to docker hub, needs PASSWORD and USERNAME
	@ docker login --username=$(USERNAME) --password=$(PASSWORD)

tag = "$(shell git rev-parse HEAD)"

push:				## Push current image to docker hub
	@echo "======= PUSHING KOHA CONTAINER ======\n"
	docker push digibib/virtuoso:$(tag)