# Dev Environment

## Abstract

* App : PHP
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx
* Tools

## Platform

* Linux - Ubuntu Desktop

## Project

### App - Symfony Framework

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

### Database - PostgreSQL

* Configure the database

```
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

```
sudo -i -u postgres
[sudo] password for user: {password}

postgres@localhost:~$ psql
psql (xx.y)
Type "help" for help.

postgres=# alter user {user_name} password {user_password}

postgres=# \q

```

### Server - Localhost

* Symfony Local Server in Dev Environment

```
vi .symfony.local.yaml

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
```

## Deployment

* Deploy this project

```
./scripts/linux/ubuntu/deploy.sh
```

### Tools

#### IDE

* Clear cache

```
./tools/ide/cache.sh
```

* Migrate databases

```
./tools/ide/migrate.sh
```

* Check status

```
./tools/ide/status.sh
```

## Reference

### Platform

* [Ubuntu Desktop](https://ubuntu.com/desktop)
