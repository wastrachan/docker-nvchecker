# nvchecker Docker Image

.PHONY: help
help:
	@echo ""
	@echo "Usage: make COMMAND"
	@echo ""
	@echo "Docker nvchecker image makefile"
	@echo ""
	@echo "Commands:"
	@echo "  build        Build and tag image"
	@echo "  push         Push tagged image to registry"
	@echo "  run          Start container in the background with locally mounted volume"
	@echo "  stop         Stop and remove container running in the background"
	@echo "  delete       Delete all built image versions"
	@echo ""

IMAGE=wastrachan/nvchecker
TAG=latest
REGISTRY=docker.io

.PHONY: build
build:
	@docker build -t ${REGISTRY}/${IMAGE}:${TAG} .

.PHONY: push
push:
	@docker push ${REGISTRY}/${IMAGE}:${TAG}

.PHONY: run
run: build
	docker run -v "$(CURDIR)/config:/config" \
	           --name nvchecker \
			   --rm \
	           -e PUID=$$(id -u) \
	           -e PGID=$$(id -g) \
	           ${REGISTRY}/${IMAGE}:${TAG}

.PHONY: stop
stop:
	@docker stop nvchecker

.PHONY: delete
delete:
	@docker image ls | grep ${IMAGE} | awk '{print $$3}' | xargs -I + docker rmi +
