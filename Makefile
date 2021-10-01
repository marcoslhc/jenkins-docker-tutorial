CMD			:=	docker

DOCKERFILE	:= ./Dockerfile

# OPTION:tag					image tag
tag			:= myjenkins-blueocean

# OPTION:version					image version
version 	:= 1.1

# OPTION:network					network name
network		:= jenkins

# OPTION:container				container name
container	:= jenkins-blue-ocean

.DEFAULT: help
all: help

# TARGET:run					run the container
.PHONY: run
run:
	@echo "Running Jenkins"
	@$(CMD) run --name $(container) --rm --detach --network $(network) --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --publish 8080:8080 --publish 50000:50000 --volume jenkins-data:/var/jenkins_home --volume jenkins-docker-certs:/certs/client:ro $(tag):$(version)

# TARGET:network					creates the network
.PHONY: network
network:
	@echo "Creating Network $(network)"
	@$(CMD) network create $(network)

# TARGET:build					Builds the image
.PHONY: build
build:
	@echo "Building $(tag):$(version)"
	@$(CMD) build -t $(tag):$(version) -f $(DOCKERFILE) .

# TARGET:logs					Show the container logs
.PHONY: logs
logs:
	@$(CMD) logs -f -t --details $(container)

# TARGET:shell					Opens a shell to the container
.PHONY: shell
shell:
	@$(CMD) exec -it $(container) bash


# TARGET:help					This help
help:
	@echo "Usage:							"
	@echo "	make <target> [OPTION=value]	"
	@echo "									"
	@echo "Options							"
	@egrep "^# OPTION:" [Mm]akefile | sed 's/^# OPTION:/	/'
	@echo "									"
	@echo "Targets:						"
	@egrep "^# TARGET:" [Mm]akefile | sed 's/^# TARGET:/	/'
