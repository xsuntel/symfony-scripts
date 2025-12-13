# Scripts - GCP (Google Cloud Platform) - Cloud Run

## Environment - Prod

## Platform - GCP (Google Cloud Platform) - [Console](https://console.cloud.google.com/)

* Products for Web App
  * API & Services
  * Billing
  * IAM & Admin
  * Cloud Storage                                            ( CDN )
  * VPC Networks
  * Cloud SQL                                                ( Database - PostgreSQL )
  * Monitoring
  * Memorystore                                              ( Cache - Redis )
  * Cloud Run                                                ( App )

### Products

#### 1. API & Services

* Enable services
  * Code Run functions
  * Artifact Registry API

#### 2. VPC Network

1) VPC networks

2) Serverless VPC access

#### 3. Cloud Storage ( Database - PostgreSQL )

#### 4. Memorystore ( Cache - Redis )

#### 5. Cloud Storage ( CDN )

#### 6. Cloud Run (App)

* Docker - Contatiners - Dockerfile
  * App : PHP
  * Server : Nginx
  * Tools : Docker Desktop : [Download](https://www.docker.com/products/docker-desktop/)

#### 7. Artifact Registry (Docker Repogitory)

* Artifact Registry

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
