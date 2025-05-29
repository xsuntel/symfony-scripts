# Scripts - Public Cloud - AWS - Elastic Beanstalk

## Environment - Prod

## Platform

* Linux : [Ubuntu Server](https://ubuntu.com/download/server/)
  * App : PHP
  * Cache : Redis
  * Database : PostgreSQL
  * Message : RabbitMQ
  * Server : Nginx

## Project

### App - Symfony Framework

* Update default variables in Prod Environment

```bash
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
NGINX_PORT=80
```

* Deploy this project

```bash
./scripts/cloud/aws/elasticbeanstalk/deploy.sh
```

### Database - PostgreSQL

* Configure databases

```bash
./tools/ide/migrate.sh
```

## Reference

### Server

* Cloud
  * AWS (Amazon Web Services)
    * [Elastic Beanstalk](https://aws.amazon.com/ko/elasticbeanstalk)
