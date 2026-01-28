# Scripts - Docker

## Platform - Linux / MacOS / Windows

### Docker - Containerss

* App : PHP + Nginx + Supervisor

## Project

* Update files Dockerfile

```bash
vi ./Dockerfile

# ======================================================================================================================
# Dockerfile - PHP-FPM & Nginx & Supervisor                                                 https://hub.docker.com/_/php
# ======================================================================================================================
ARG PHP_VERSION="8.4"

```

### Dev Environment

#### Requirement

* Update default variables in Dev Environment

```bash
vi .env.prod.local

# ======================================================================================================================
# Symfony Framework - Prod Environment                                   https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> Cache - Redis
REDIS_HOST=host.docker.internal
REDIS_PORT=6379

# >>>> Database - PostgreSQL
POSTGRES_HOST=host.docker.internal
POSTGRES_PORT=5432

# >>>> Message - RabbitMQ
RABBITMQ_HOST=host.docker.internal
RABBITMQ_PORT=5672
```

#### Deployment in Dev

* Docker

```bash
docker login -u <username>

vi ~/.docker/config.json
```

```bash
docker system prune -a -f --filter "label=purpose=webapp"
```

* Debug this project

```bash
./scripts/containers/prod/debug.sh
```

## Reference

### Tools

* [Release notes](https://docs.docker.com/desktop/release-notes/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
