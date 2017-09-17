IMAGE_NAME = sinatra-skeleton
DOCKER_ID := $(shell docker ps | grep $(IMAGE_NAME) | cut -d ' ' -f 1)

all: usage

usage:
	@echo "Usage: make [build|start|stop|status]"

build:
	@docker build --tag=$(IMAGE_NAME) .

start:
ifndef DOCKER_ID
	@docker run -d -p 5000:5000 $(IMAGE_NAME)
	@echo "Container started"
else
	@echo "Container is already running"
	@echo "ID: $(DOCKER_ID)"
endif

stop:
ifndef DOCKER_ID
	@echo "Container is not running"
else
	@docker kill $(DOCKER_ID)
	@echo "Container stopped"
endif

status:
ifndef DOCKER_ID
	@echo "Container is not running"
else
	@docker ps | grep $(IMAGE_NAME)
endif
