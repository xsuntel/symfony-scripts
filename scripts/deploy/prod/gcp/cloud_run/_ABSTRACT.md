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

#### 2. IAM & Admin

* Permissions for {project_name on GCP}
  * Principal : {User}
    * Role : Storage Object Viewer

#### 3. VPC Network

* VPC networks

* Serverless VPC access

#### 4. Cloud Storage ( Database - PostgreSQL )

#### 5. Memorystore ( Cache - Redis )

#### 6. Cloud Storage ( CDN )

#### 7. Artifact Registry (Docker Repogitory)

* Google Cloud CLI

  * Log into an account of GCP

  ```bash
  gcloud auth login
  ```

  * Log into an account of GCP

  ```bash
  gcloud config set project {project_name on GCP}
  ```

  * Create a repogitory on Artifact

  ```bash
  gcloud artifact repositories create {webapp_repo} --repository--format=docker --location={europe-west3} --description="Web App" --immutable-tags --asyc
  ```

  ```bash
  gcloud auth configure-docker {europe-west4-docker.pkg.dev}
  ```

  ```bash
  gcloud builds submit --tag europe-west4-docker.pkg.dev/{project_name on GCP}/{webapp_repo}/{image_name}:{tag}
  ```

* Test image in local

  ```bash
  docker build . --tag europe-west4-docker.pkg.dev/{project_name on GCP}/{webapp_repo}/{image_name}:{tag}
  ```

  ```bash
  docker push europe-west4-docker.pkg.dev/{project_name on GCP}/{webapp_repo}/{image_name}:{tag}
  ```

#### 8. Cloud Run (App)

* Docker - Contatiners - Dockerfile
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
* Docker Desktop : [Download](https://www.docker.com/products/docker-desktop/)
