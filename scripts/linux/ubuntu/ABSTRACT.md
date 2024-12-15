# Linux - Ubuntu Desktop

## Dev Environment

### Platform

* App : PHP
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx
* Tools

### Project

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

### App

#### Symfony Framework

* Deploy this project

```
./scripts/linux/ubuntu/deploy.sh
```

### Database

#### PostgreSQL

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

* Configure databases

```
./tools/ide/migrate.sh
```

### Tools

#### IDE

* Update packages in Dev Environment

```
./scripts/linux/ubuntu/server/local.sh
```

## Reference

### Platform

* [Ubuntu Desktop](https://ubuntu.com/desktop)
