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

* Update default variables in Prod Environment

```
vi .env.prod

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App


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
NGINX_HOST={Your Domain}
NGINX_PORT=443
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
