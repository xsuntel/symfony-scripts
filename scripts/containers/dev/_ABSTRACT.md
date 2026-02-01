# Scripts - Docker

## Platform - Linux / MacOS / Windows

## Project

### Docker - Containerss

* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Utility : pgAdmin, Mailer

```bash
vi ./docker-composer.env

# ======================================================================================================================
# Symfony Framework - Dev Environment                                   https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> Cache
REDIS_PORT=6379                                                       # REDIS_NETWORK_PORT    ---> REDIS_PORT      6379

# >>>> Database
POSTGRES_PORT=5432                                                    # POSTGRES_NETWORK_PORT ---> POSTGRES_PORT   5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Message
RABBITMQ_NETWORK_PORT=5672                                            # RABBITMQ_NETWORK_PORT ---> POSTGRES_PORT   5672

# ----------------------------------------------------------------------------------------------------------------------
# Utility
# ----------------------------------------------------------------------------------------------------------------------

# >>>> pgAdmin
PGADMIN_NETWORK_PORT=5433                                             # PGADMIN_NETWORK_PORT  ---> POSTGRES_PORT   5433

# >>>> Mailer
MAILER_NETWORK_HTTP_PORT=1180
MAILER_NETWORK_SMTP_PORT=1125
```

## Deployment

* Docker

```bash
docker login -u <username>

vi ~/.docker/config.json
```

## Reference

### Tools

* [Release notes](https://docs.docker.com/desktop/release-notes/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
