# AWS (Amazon Web Services) - Compute - Elastic Beanstalk

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* App (PHP) + Cache (Redis) + Database (PostgreSQL) + Server (Nginx)

## Prod Environment

### Platform

* Linux
* MacOS
* Windows

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

#### 1) Deploy this application

* Deploy this project

```
./scripts/cloud/aws/elasticbeanstalk/deploy.sh
```

## Reference

### Server

* Cloud
    * AWS (Amazon Web Services)
        * [Elastic Beanstalk](https://aws.amazon.com/ko/elasticbeanstalk)
