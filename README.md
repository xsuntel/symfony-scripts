# Symfony Scripts

## Abstract

This project includes some shell-scripts for Full-Stack developer to develop a web application using [Symfony Framework](https://symfony.com)

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

### Requirement

* Update your name for Git

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

```
git config --local core.editor vi
git config --local core.autocrlf false
git config --local color.ui true
git config --local diff.ui auto
git config --local format.pretty oneline
git config --local pull.rebase true
git config --local push.default simple

git config --local --list
```

* Check the latest version of Symfony - [Releases](https://symfony.com/releases)

  * Update Default variables
  
```
vi env.app
```

* Creating Symfony Applications - [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)

```
./tools/tutorial/create.sh
```

### Deployment

#### App

* Linux
  * Ubuntu                - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/linux/ubuntu/ABSTRACT.md)
* Macos
  * Desktop               - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/macos/device/ABSTRACT.md)
* Windows
  * Desktop               - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/windows/device/ABSTRACT.md)

#### Tools

* Check status

```
./tools/ide/check.sh
```

* Migrate databases

```
./tools/ide/migrate.sh
```

* Update some sources and Debugging it in Dev Environment

```
./tools/ide/update.sh
```

### Production

* Public Cloud
  * AWS (Amazon Web Services)
    * Elastic Beanstalk   - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/elasticbeanstalk/Abstract.md)
    * Lightsail           - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/lightsail/Abstract.md)
* Docker
  * Containers            - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/docker/containers/Abstract.md)

#### Update the project

```
git config pull.rebase true

git reset --hard

git pull origin main -f
```

### Directories 

* [Symfony Framework](https://symfony.com)

```
    app/
    
        | -- Symfony Framework -- |

    diagrams/
        cloud/
          aws/
        instance/
          app/
          cache/
          database/
          server/
          tools/
        source/
          ...
    scripts/
        base/
        cloud/
        docker/
        linux/
        macos/
        windows/
    tests/
    tools/
        console/
        git/
        ide/
        tutorial/
    .env.app
    .env.dev
    .env.dev.local
    .env.prod
    .gitignore
    .symfony.local.yaml
    docker-compose.yml
    LICENSE
    phpunit.xml.dist
    README.md
```

## Tutorial

* [SymfonyCasts](https://symfonycasts.com)

## Reference

* GitHub - [Wiki](https://github.com/xsuntel/symfony-scripts/wiki)

## License
This is available under the MIT License.
