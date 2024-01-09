# Docker

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* App (PHP) + Cache (Redis) + Database (PostgreSQL) + Server (Nginx)

## Dev Environment

* Docker
  * Docker Desktop
    - Core   : 6
    - Memory : 6 GB
    - Swap   : 2 GB
    - Disk   : 128 GB

### Platform

* Linux
* MacOS
* Windows

#### 1) Create a new directory

* Work Directory

```
[user@localhost] cd ~
[user@localhost] mkdir -p Applications && cd Applications
[user@localhost] mkdir -p PhpStorm && cd PhpStorm
[user@localhost] mkdir -p github && cd github
```

#### 2) Download this project

* Git

```
[user@localhost] git config --global user.name "your_name"
[user@localhost] git config --global user.email "your_email_address"

[user@localhost] git clone https://github.com/xsuntel/symfony-scripts.git symfony

[user@localhost] cd symfony
[user@localhost] find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

#### 3) Check current environment

* Install related some packages for developing application

```
[user@localhost] ./tools/ide/phpstorm/check.sh
```

#### 4) Deploy this project

* Deploy this project

```
[user@localhost] ./scripts/docker/containers/deploy.sh
```

* Migrate the related databases

```
[user@localhost] ./scripts/docker/containers/migrate.sh
```

* Debugging sources and Resolve it

```
[user@localhost] ./scripts/vm/ubuntu/resolve.sh
```

* Check status of the system

```
[user@localhost] ./scripts/vm/ubuntu/status.sh
```

### Scripts

* Docker - Container - PostgreSQL

  * Configure the database

```
[root@localhost] sudo -i -u postgres
[sudo] password for {your_name}: {your_password}

postgres@localhost:~$ psql
psql (14.8 (Ubuntu 14.8-0ubuntu0.22.04.1))
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
[user@localhost] sudo -i -u postgres
[sudo] password for {your_name}: {your_password}

postgres@localhost:~$ psql
psql (14.8 (Ubuntu 14.8-0ubuntu0.22.04.1))
Type "help" for help.

postgres=# alter user {user_name} password '{user_password}'

postgres=# \q

```

* Update a configuration

```
[user@localhost] sudo cat /etc/postgresql/14/main/postgresql.conf | grep -i listen_addresses
```

## Reference

### Tools

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) - [Release notes](https://docs.docker.com/desktop/release-notes/)
