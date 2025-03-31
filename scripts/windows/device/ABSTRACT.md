# Dev Environment

## Abstract

* App : PHP
* Cache : Redis (Docker Container)
* Database : PostgreSQL (Docker Container)
* Message : RabbitMQ (Docker Container)
* Server : Symfony Local Server
* Tools : Docker Desktop : [Download](https://www.docker.com/products/docker-desktop/)

## Platform

* Windows

## Project

### App - Symfony Framework

* Create APP_SECRET

```
$ date | md5
```

* Update default variables in Dev Environment


```
vi .env.dev

# ======================================================================================================================
# Symfony Framework - Dev Environment                                    https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> Cache
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# >>>> Database
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432                                                    # POSTGRES_NETWORK_PORT ---> POSTGRES_PORT   5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Message
RABBITMQ_VERSION=3
RABBITMQ_HOST=127.0.0.1
RABBITMQ_PORT=5672

# >>>> Server
NGINX_HOST=127.0.0.1
NGINX_PORT=8000
```

```
vi .env.dev.local

# ======================================================================================================================
# Symfony Framework - Dev Environment - Local                            https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> Database - PostgreSQL - Docker
POSTGRES_PORT=15432
```

* Update docker-compose's variables in Dev Environment

```
vi docker/containers/docker-compose.env.dev

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> Database
POSTGRES_NETWORK_BACKEND_IP_ADDRESS=172.31.0.31
POSTGRES_NETWORK_PORT=15432
POSTGRES_HOST=${POSTGRES_NETWORK_BACKEND_IP_ADDRESS}
POSTGRES_PORT=5432
POSTGRES_DB=app
POSTGRES_USER=symfony
POSTGRES_PASSWORD=!ChangeMe!

# ----------------------------------------------------------------------------------------------------------------------
# Tools
# ----------------------------------------------------------------------------------------------------------------------
# >>>> Database - pgAdmin                                                        https://hub.docker.com/r/dpage/pgadmin4
PGADMIN_NETWORK_FRONTEND_IP_ADDRESS=172.21.0.61
PGADMIN_NETWORK_BACKEND_IP_ADDRESS=172.31.0.61
PGADMIN_NETWORK_PORT=15433
PGADMIN_HOST=${PGADMIN_NETWORK_BACKEND_IP_ADDRESS}
PGADMIN_DEFAULT_EMAIL=pgadmin@example.com
#PGADMIN_DEFAULT_EMAIL=${GIT_CONFIG_LOCAL_USER_EMAIL}
PGADMIN_DEFAULT_PASSWORD=!ChangeMe!
PGADMIN_MAIL=${PGADMIN_DEFAULT_EMAIL}
PGADMIN_PW=${PGADMIN_DEFAULT_PASSWORD}

# >>>> Mailer                                                            https://hub.docker.com/r/schickling/mailcatcher
MAILER_NETWORK_BACKEND_IP_ADDRESS=172.31.0.71
MAILER_NETWORK_HTTP_PORT=1180
MAILER_NETWORK_SMTP_PORT=1125
```

* Symfony Local Server in Dev Environment

```
vi .symfony.local.yaml

# ----------------------------------------------------------------------------------------------------------------------
# Local Web Server                                                                            PATH : ${PROJECT_PATH}/app
# ----------------------------------------------------------------------------------------------------------------------
http:
  document_root: public/
  passthru: index.php
  port: 8000
  preferred_port: 8001
  #p12: ./config/authentication/p12_cert
  allow_http: true
  no_tls: true
  daemon: true
  use_gzip: true
```

* Deploy this project

```
./scripts/windows/device/deploy.sh
```

### Message - RabbitMQ

* Check local website

```
http://localhost:15672

    - ID : guest
    - PW : guest
```

### Tools

#### IDE

* Update packages in Dev Environment

```
./scripts/windows/device/server/local.sh
```

## Reference

### Platform

* [Windows](https://www.microsoft.com/)