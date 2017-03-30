.PHONY: all build

build:
	@echo "======= FORCE RECREATING image ======\n"
	docker stop virtuoso && true &&\
	docker rm -f virtuoso || true &&\
	docker build virtuoso &&\
	docker up --force-recreate --no-deps -d virtuoso

run:
	docker up -d virtuoso || true

stop:
	docker stop virtuoso || true

login: 				## Log in to docker hub, needs PASSWORD and USERNAME
	@ docker login --username=$(USERNAME) --password=$(PASSWORD)

tag = "$(shell git rev-parse HEAD)"

tag:				## Tag image from current GITREF
	docker tag -f digibib/virtuoso digibib/virtuoso:$(tag)

push:				## Push current image to docker hub
	@echo "======= PUSHING IMAGE ======\n"
	docker push digibib/virtuoso:$(tag)
