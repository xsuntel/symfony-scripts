# Scripts

## Dev Environment

### Platform

* MacOS - Install Docker Desktop : [Download](https://www.docker.com/products/docker-desktop/)
    * App : PHP
    * Cache : Redis (Docker Container)
    * Database : PostgreSQL (Docker Container)
    * Message : RabbitMQ (Docker Container)
    * Server : Symfony Local Server

### Project

* Update default variables

```
vi {PROJECT_PATH}/.env.dev

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
LOCAL_URL_HOST=127.0.0.1
LOCAL_URL_PORT=8000

# >>>> Cache
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# >>>> Database
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=15432                                                    # POSTGRES_NETWORK_PORT ---> POSTGRES_PORT   5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Server
PUBLIC_URL_HOST=127.0.0.1
PUBLIC_URL_PORT=8000
```

* Symfony Local Server

```
vi {PROJECT_PATH}/.symfony.local.yaml

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

### App

#### Symfony Framework

* Deploy this project

```
./scripts/macos/device/deploy.sh
```

### Database

#### PostgreSQL

* Update databases
    * create
    * schema

```
./scripts/tools/ide/migrate.sh
```

### Message

#### RabbitMQ

* Install a package

```
brew search rabbitmq-c
brew install rabbitmq-c

ls -ltr /opt/homebrew/Cellar/rabbitmq-c/0.14.0
```

* Update a configuration

```
Set the path to librabbitmq install prefix [autodetect] : /opt/homebrew/Cellar/rabbitmq-c/0.14.0
```

### Tools

#### IDE

* Update packages in Dev Environment

```
./scripts/macos/device/tools/local.sh
```

## Reference

### Platform

* [MacOS](https://www.apple.com/kr/macos)
