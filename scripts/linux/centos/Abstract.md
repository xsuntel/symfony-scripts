# CentOS

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* App (PHP) + Cache (Redis) + Database (PostgreSQL) + Server (Nginx)

## Dev Environment

### Instances - CentOS

* Install required packages

```
[user@localhost] cd ~/Downloads
[user@localhost] sudo apt update -y
[user@localhost] sudo apt install -y curl git wget net-tools
[user@localhost] sudo apt autoremove -y
```

#### 1) Create a new directory

* Work Directory

```
[user@localhost] sudo mkdir -p /var/www
[user@localhost] sudo mkdir -p /var/www/github
[user@localhost] sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github
```

#### 2) Download this project

* Git

```
[user@localhost] cd /var/www/github
[user@localhost] git clone https://github.com/xsuntel/symfony-scripts.git symfony

[user@localhost] cd symfony
[user@localhost] find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

#### 3) Deploy this project

* Deploy this project

```
[user@localhost] ./scripts/linux/centos/deploy.sh
```

### Database - PostgreSQL

* Configure the database

```
[root@localhost] cd /var/www/github/symfony

[root@localhost] sudo -i -u postgres
[sudo] password for parallels: {password}

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
[user@localhost] cd /var/www/github/symfony

[user@localhost] sudo -i -u postgres
[sudo] password for parallels: {password}

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

### Server
* [CentOS](https://centos.org)