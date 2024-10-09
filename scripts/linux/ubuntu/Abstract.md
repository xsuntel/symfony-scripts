# Scripts

## Dev Environment

### Platform

* Linux - Ubuntu Desktop
    * App : PHP
    * Cache : Redis
    * Database : PostgreSQL
    * Message : RabbitMQ
    * Server : Nginx

### Project

* Create APP_SECRET

```
$ date | md5
```

* Update default variables in Dev Environment


```
vi .env.dev

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
00

# >>>> Cache
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# >>>> Database
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Server
NGINX_HOST=127.0.0.1
NGINX_PORT=8000
```

* Update packages

```
cd ~/Downloads

sudo apt update -y
sudo apt install -y curl git wget unzip
sudo apt remove --purge -y ubuntu-advantage*
sudo apt autoremove -y
```

* Work Directory

```
sudo mkdir -p /var/www
sudo mkdir -p /var/www/github
sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github

cd /var/www/github && if [ -d symfony ]; then rm -rf symfony ; fi
```

* Download this project

```
git clone https://github.com/xsuntel/symfony-scripts.git symfony

cd symfony && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
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
[root@localhost] cd /var/www/github/symfony

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
cd /var/www/github/symfony

sudo -i -u postgres
[sudo] password for user: {password}

postgres@localhost:~$ psql
psql (xx.y)
Type "help" for help.

postgres=# alter user {user_name} password {user_password}

postgres=# \q

```

* Update a configuration

```
sudo cat /etc/postgresql/14/main/postgresql.conf | grep -i listen_addresses
```

* Update databases
    * create
    * schema

```
./scripts/tools/ide/migrate.sh
```

### Tools

#### IDE

* Update packages in Dev Environment

```
./scripts/linux/ubuntu/tools/local.sh
```

## Reference

### Platform

* [Ubuntu Desktop](https://ubuntu.com/desktop)
