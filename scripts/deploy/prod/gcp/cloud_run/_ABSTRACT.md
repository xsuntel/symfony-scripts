# Scripts - GCP (Google Cloud Platform) - Cloud Run

## Environment - Prod

## Platform

* Docker - Contatiners
  * App : PHP
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

## Deployment

* Deploy this project

```bash
./scripts/deploy/prod/gcp/cloud_run/deploy.sh
```

### Database - PostgreSQL

* Configure databases

```bash
./scripts/deploy/migrate.sh
```

## Reference

### Public Cloud

* GCP (Google Cloud Platform)
  * [Code Run](https://cloud.google.com/run)
    * [Google Cloud CLI](https://docs.cloud.google.com/sdk/docs/install-sdk)
      * [PHP](https://docs.cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-php-service)
