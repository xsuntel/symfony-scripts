# Scripts

## Prod Environment

### Platform

* Linux - [Ubuntu Server](https://ubuntu.com/download/server/arm)
    * App : PHP
    * Cache : Redis
    * Database : PostgreSQL
    * Message : RabbitMQ
    * Server : Nginx

### Project

* Update default variables

```
vi .env.prod

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
LOCAL_URL_HOST=127.0.0.1
LOCAL_URL_PORT=80

# >>>> Cache
REDIS_HOST={Your Host}
REDIS_PORT=6379

# >>>> Database
POSTGRES_HOST={Your Host}
POSTGRES_PORT=5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Server
PUBLIC_URL_HOST={Your Domain}
PUBLIC_URL_PORT=443
```

### App

#### Symfony Framework

* Deploy this project

```
./scripts/cloud/aws/elasticbeanstalk/deploy.sh
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

### Server

* Cloud
    * AWS (Amazon Web Services)
        * [Elastic Beanstalk](https://aws.amazon.com/ko/elasticbeanstalk)
