# Scripts - Linux

## Environment - Dev

## Platform

* Linux - Ubuntu Desktop
  * App : PHP
  * Cache : Redis
  * Database : PostgreSQL
  * Message : RabbitMQ
  * Server : Nginx
  * Tools

## Project

### App - Symfony Framework

* Update default variables in Dev Environment

```bash
vi .env.dev

# ======================================================================================================================
# Symfony Framework - Dev Environment                                    https://symfony.com/doc/current/deployment.html
# ======================================================================================================================

# >>>> Cache
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# >>>> Database
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Message
RABBITMQ_VERSION=3
RABBITMQ_HOST=127.0.0.1
RABBITMQ_PORT=15672

# >>>> Server
NGINX_HOST=127.0.0.1
NGINX_PORT=8000
```

* Update a part of configurations for twig in dev

```bash
vi {project_directory}/app/config/packages/dev/twig.yaml

when@dev:
  twig:
    debug: true
    cache: {project_directory}/app/var/cache/dev
    auto_reload: true
    strict_variables: true
    #autoescape: html
    #optimizations: -1
```

### Database - PostgreSQL

* Configure the database

```bash
[root@localhost] sudo -i -u postgres
[sudo] password for user: {password}

postgres@localhost:~$ psql
psql (xx.y)
Type "help" for help.

postgres=# create user symfony password '!ChangeMe!' superuser;
CREATE ROLE
postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 symfony   | Superuser                                                  | {}

postgres=# \q

```

* Change the user's password

```bash
sudo -i -u postgres
[sudo] password for user: {password}

postgres@localhost:~$ psql
psql (xx.y)
Type "help" for help.

postgres=# alter user {user_name} password {user_password}

postgres=# \q

```

### Message - RabbitMQ

* Check local website

```text
http://localhost:15672

    - ID : guest
    - PW : guest
```

### Server - Localhost

* Symfony Local Server in Dev Environment

```bash
vi ./tools/.symfony.local.yaml

# ----------------------------------------------------------------------------------------------------------------------
# Local Web Server                                                                            PATH : ${PROJECT_PATH}/app
# ----------------------------------------------------------------------------------------------------------------------
http:
  document_root: public/
  passthru: index.php
  port: 8080
  preferred_port: 8081
  #p12: ./config/authentication/p12_cert
  allow_http: true
  no_tls: true
  daemon: true
  use_gzip: true
  no_workers: true
```

## Deployment

* Deploy this project

```bash
./scripts/deploy/linux/ubuntu/deploy.sh
```

### Scripts

#### App

* Clear cache

```bash
./tools/clear.sh
```

#### Database

* Migrate databases

```bash
./tools/migrate.sh
```

#### Server

* Check status

```bash
./tools/status.sh
```

## Reference

* [Ubuntu Desktop](https://ubuntu.com/desktop)
