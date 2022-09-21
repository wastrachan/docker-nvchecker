# docker-nvchecker makefile
#
# Copyright (c) Winston Astrachan 2022

help:
	@echo ""
	@echo "Usage: make COMMAND"
	@echo ""
	@echo "docker-nvchecker makefile"
	@echo ""
	@echo "Commands:"
	@echo "  build        Build and tag image"
	@echo "  run          Start container with locally mounted config volume"
	@echo "  clean        Mark image for rebuild"
	@echo "  delete       Delete image and mark for rebuild"
	@echo ""

build: .docker-nvchecker.img

.docker-nvchecker.img:
	docker build -t wastrachan/nvchecker:latest .
	@touch $@

.PHONY: run
run: build
	docker run -v "$(CURDIR)/config:/config" \
	           --name nvchecker \
	           --rm \
	           -e PUID=1000 \
	           -e PGID=1000 \
	           wastrachan/nvchecker:latest

.PHONY: clean
clean:
	rm -f .docker-nvchecker.img

.PHONY: delete
delete: clean
	docker rmi -f wastrachan/nvchecker
