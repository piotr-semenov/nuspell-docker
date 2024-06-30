-include dockerfile-commons/recipes/clean-docker.mk
-include dockerfile-commons/recipes/lint-dockerfiles.mk
-include dockerfile-commons/recipes/test-dockerfiles.mk
-include dockerfile-commons/docker-funcs.mk

SHELL := /bin/bash

IMAGE_NAME = semenovp/tiny-nuspell
NUSPELL_VER ?= 5.1.4

VCS_REF=$(shell git rev-parse --short HEAD)


.PHONY: help
help:  ## Prints the help.
	@echo 'Commands:'
	@grep --no-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) |\
	 awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'


.DEFAULT_GOAL := all
.PHONY: all
all: lint-dockerfiles build clean test;


.PHONY: build
build: export BUILD_ARGS='nuspell_version="$(NUSPELL_VER)" vcsref="$(VCS_REF)"'
build:  ## Builds the image for Nuspell.
	@$(call build_docker_image,"$(IMAGE_NAME):latest","$(BUILD_ARGS)",".")


.PHONY: clean
clean: clean-docker;


.PHONY: test
test:  ## Tests the the already built docker image.
	$(call goss_docker_image,"$(IMAGE_NAME):latest","tests/nuspell.yaml","nuspell_version=$(NUSPELL_VER)","-v $$(pwd)/tests/hunspell/:/usr/share/hunspell")
