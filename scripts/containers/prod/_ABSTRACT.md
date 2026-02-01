# Scripts - Docker

## Platform - Linux / MacOS / Windows

## Project

### Docker - Containerss

* App : PHP + Nginx + Supervisor

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

### Deployment

* Test this project

```bash
./scripts/containers/prod/test.sh
```

## Reference

### Tools

* [Release notes](https://docs.docker.com/desktop/release-notes/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
