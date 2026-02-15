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

# >>>> Cache - Redis - Docker - Network - Back-End IP Address
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# >>>> Database - PostgreSQL - Docker - Network - Back-End IP Address
POSTGRES_VERSION=16
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432

# >>>> Message - RabbitMQ - Docker - Network - Back-End IP Address
RABBITMQ_HOST=127.0.0.1
RABBITMQ_PORT=5672

# >>>> Server - Symfony Local Web Server
NGINX_SCHEME=http
NGINX_HOST=127.0.0.1
NGINX_PORT=8000
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
