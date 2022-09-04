USER = $(shell whoami)
UID = $(shell id -u)
GID = $(shell id -g)
PWD = $(shell pwd)
NODE_IMAGE = node:lts-slim
PKG_MANAGER = yarn
COMPOSER = composer:2

.PHONY: docker-build
docker-build:
	docker-compose build

.PHONY: docker-up
docker-up:
	docker-compose up --force-recreate

# composer standalone containers are only used to install dependencies
.PHONY: deps-back-install
deps-back-install:
	docker run --rm -ti -v $(PWD):/app --user $(UID):$(GID) $(COMPOSER) install

# composer standalone containers are only used to install dependencies
.PHONY: deps-back-update
deps-back-update:
	docker run --rm -ti -v $(PWD):/app --user $(UID):$(GID) $(COMPOSER) update

.PHONY: deps-front-install
deps-front-install:
	docker run -ti --rm -u node -w /home/node/app -v $(PWD):/home/node/app $(NODE_IMAGE) $(PKG_MANAGER) install

.PHONY: deps-front-upgrade
deps-front-upgrade:
	docker run -ti --rm -u node -w /home/node/app -v $(PWD):/home/node/app $(NODE_IMAGE) $(PKG_MANAGER) upgrade

.PHONY: watch
watch:
	docker run -ti --rm -u node -w /home/node/app -v $(PWD):/home/node/app $(NODE_IMAGE) $(PKG_MANAGER) watch

.PHONY: database
database:
	docker-compose exec php composer database

.PHONY: database-dev
database-dev:
	docker-compose exec php composer database-dev

.PHONY: database-test
database-test:
	docker-compose exec php composer database-test

.PHONY: php
php:
	docker-compose exec php bash
