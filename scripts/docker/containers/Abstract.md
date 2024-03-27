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

### App

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

## Reference

### Tools

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) - [Release notes](https://docs.docker.com/desktop/release-notes/)
