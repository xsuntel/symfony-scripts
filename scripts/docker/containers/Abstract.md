# Scripts

## Prod/Dev Environment

### Platform

* Linux - Install Docker Desktop : [Download](https://www.docker.com/products/docker-desktop/)
* MacOS - Install Docker Desktop : [Download](https://www.docker.com/products/docker-desktop/)
* Windows - Install Docker Desktop : [Download](https://www.docker.com/products/docker-desktop/)

### Project

* Update default variables in Prod Environment

```
vi .env.prod

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
00

# >>>> Cache
REDIS_HOST=127.0.0.1
REDIS_PORT=16379                                                       # REDIS_NETWORK_PORT    ---> REDIS_PORT      6379

# >>>> Database
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=15432                                                    # POSTGRES_NETWORK_PORT ---> POSTGRES_PORT   5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Server
NGINX_HOST=127.0.0.1
NGINX_PORT=8000
```

* Update files related docker-compose in Prod Environment

```
vi ./docker-composer.prod.env

# ======================================================================================================================
# Docker - Docker-Compose                                                   https://docs.docker.com/compose/compose-file
# ======================================================================================================================
# >>>> Dev Environment                                                            TCP Port numbers range from 0 to 65536
DOCKER_ENVIRONMENT=dev
DOCKER_WORKDIR="/var/www/github/symfony"

DOCKER_NETWORK_FRONTEND_IPAM_CONFIG_SUBNET=172.21.0.0/24
DOCKER_NETWORK_BACKEND_IPAM_CONFIG_SUBNET=172.31.0.0/24

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
PHP_NETWORK_BACKEND_IP_ADDRESS=172.31.0.11

# >>>> Cache
REDIS_NETWORK_BACKEND_IP_ADDRESS=172.31.0.21
REDIS_NETWORK_PORT=16379
REDIS_HOST=${REDIS_NETWORK_BACKEND_IP_ADDRESS}
REDIS_PORT=6379

# >>>> Database
POSTGRES_NETWORK_BACKEND_IP_ADDRESS=172.31.0.31
POSTGRES_NETWORK_PORT=15432
POSTGRES_HOST=${POSTGRES_NETWORK_BACKEND_IP_ADDRESS}
POSTGRES_PORT=5432
POSTGRES_DB=app
POSTGRES_USER=symfony
POSTGRES_PASSWORD=!ChangeMe!

# >>>> Message
RABBITMQ_NETWORK_BACKEND_IP_ADDRESS=172.31.0.41
RABBITMQ_NETWORK_PORT=15672
RABBITMQ_HOST=${RABBITMQ_NETWORK_BACKEND_IP_ADDRESS}
RABBITMQ_PORT=5672

# >>>> Server
NGINX_NETWORK_FRONTEND_IP_ADDRESS=172.21.0.51
NGINX_NETWORK_BACKEND_IP_ADDRESS=172.31.0.51
NGINX_NETWORK_PORT=8000
NGINX_HOST=${NGINX_NETWORK_FRONTEND_IP_ADDRESS}
NGINX_PORT=80
NGINX_HEALTHCHECK_FILE=healthcheck.php

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------
# >>>> Database - pgAdmin                                                        https://hub.docker.com/r/dpage/pgadmin4
PGADMIN_NETWORK_FRONTEND_IP_ADDRESS=172.21.0.61
PGADMIN_NETWORK_BACKEND_IP_ADDRESS=172.31.0.61
PGADMIN_NETWORK_PORT=15433
PGADMIN_HOST=${PGADMIN_NETWORK_BACKEND_IP_ADDRESS}
PGADMIN_DEFAULT_EMAIL=${GIT_CONFIG_LOCAL_USER_EMAIL}
PGADMIN_DEFAULT_PASSWORD=!ChangeMe!
PGADMIN_MAIL=${PGADMIN_DEFAULT_EMAIL}
PGADMIN_PW=${PGADMIN_DEFAULT_PASSWORD}

# >>>> Mailer                                                            https://hub.docker.com/r/schickling/mailcatcher
MAILER_NETWORK_BACKEND_IP_ADDRESS=172.31.0.71
MAILER_NETWORK_HTTP_PORT=1080
MAILER_NETWORK_SMTP_PORT=1025
```

### App

#### Symfony Framework

* Deploy this project

```
./scripts/docker/containers/deploy.sh
```

### Database

#### PostgreSQL

* Update databases
    * create
    * schema

```
./scripts/tools/ide/migrate.sh
```

## Reference

### Tools

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) - [Release notes](https://docs.docker.com/desktop/release-notes/)
