-include dockerfile-commons/recipes/lint-dockerfiles.mk
-include dockerfile-commons/docker-funcs.mk

SHELL := /bin/bash

IMAGE_NAME = semenovp/tiny-nuspell
NUSPELL_VER ?= v5.1.4

VCS_REF=$(shell git rev-parse --short HEAD)


.PHONY: help
help:  ## Prints the help.
	@echo 'Commands:'
	@grep --no-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) |\
	 awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'


.DEFAULT_GOAL := build
build: lint-dockerfiles build_nuspell;  ## Builds the docker image.


.PHONY: build_nuspell
build_nuspell: export BUILD_ARGS='nuspell_version="$(NUSPELL_VER)" vcsref="$(VCS_REF)"'
build_nuspell:  ## Builds the image for Nuspell.
	$(call build_docker_image,"$(IMAGE_NAME):latest","$(BUILD_ARGS)",".")
