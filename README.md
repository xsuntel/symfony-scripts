# Symfony Scripts

## Abstract

This project includes some shell-scripts for Full-Stack developer to develop a web application using Symfony Framework

* App : PHP
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx

## Platform

### Linux

* Work Directory

```
sudo mkdir -p /var/www
sudo mkdir -p /var/www/github
sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github

cd /var/www/github
```

### MacOS

* Work Directory

```
mkdir -p ~/Applications
mkdir -p ~/Applications/PhpStorm
mkdir -p ~/Applications/PhpStorm/GitHub

cd ~/Applications/PhpStorm/GitHub
```

### Windows

* Work Directory

```
mkdir -p ~/Applications
mkdir -p ~/Applications/PhpStorm
mkdir -p ~/Applications/PhpStorm/GitHub

cd ~/Applications/PhpStorm/GitHub
```

## Project

### Directories

*  [Symfony Framework](https://symfony.com)

```
    app/
    
        | -- Symfony Framework -- |

    diagrams/
        cloud/
        servers/
        source/
    scripts/
        base/
        cloud/
        docker/
        linux/
        macos/
        windows/
    tools/
        console/
        git/
        ide/
        tutorial/
    .env.app
    .env.dev
    .env.dev.local
    .env.prod
    .env.prod.local
    .gitignore
    .symfony.local.yaml
    docker-compose.yml
    LICENSE
    README.md
```

### Requirement

* Update your name and email for Git

```
git config --global user.name "Your Name"
git config --global user.email "you@examle.com"

git config --global init.defaultBranch main
git config --global credential.helper store

git config --global --list
```

* Download this project 

```
git clone https://github.com/xsuntel/symfony-scripts.git symfony

cd symfony && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

* Check default variables and the latest version of Symfony - [Releases](https://symfony.com/releases)

```
vi env.app

# >>>> PHP
SYMFONY_VERSION=7.2.*
```

### Download Symfony

* Creating Symfony Applications - [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)

```
./tools/tutorial/create.sh
```

### Deployment

#### Platform

* Linux
  * Ubuntu                - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/linux/ubuntu/ABSTRACT.md)
```
./scripts/linux/ubuntu/deploy.sh
```
* Macos
  * Desktop               - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/macos/device/ABSTRACT.md)
```
./scripts/macos/device/deploy.sh
```
* Windows
  * Desktop               - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/windows/device/ABSTRACT.md)
```
./scripts/windows/device/deploy.sh
```

#### Tools - IDE

* Check status

```
./tools/ide/check.sh
```

* Update security rules for Firewall

```
./tools/ide/firewall.sh
```

* Update localhost

```
./tools/ide/hosts.sh
```

* Migrate databases

```
./tools/ide/migrate.sh
```

* Clear cache

```
./tools/ide/update.sh
```

### Production
* Public Cloud
  * AWS (Amazon Web Services)
    * Elastic Beanstalk   - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/elasticbeanstalk/ABSTRACT.md)
    * Lightsail           - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/lightsail/ABSTRACT.md)

## Tutorial

* [SymfonyCasts](https://symfonycasts.com)

## Reference

* Tools
  * GitHub - [Wiki](https://github.com/xsuntel/symfony-scripts/wiki)

## License
This is available under the MIT License.
