# Symfony Scripts

## Abstract

This project includes some shell-scripts for Full-Stack developer to develop a web application using Symfony Framework

* App : PHP - [Symfony Framework](https://symfony.com)
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx

## Platform

* Linux
* MacOS
* Windows

## Project

### Directories

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
        server/
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

* Work Directory

```
mkdir -p ~/Applications
mkdir -p ~/Applications/GitHub

cd ~/Applications/GitHub
```

### Dev Environment

#### Requirement

* Update your name and email for Git

```
git config --global user.name "{Your Name}"
git config --global user.email "{Your Email}"

git config --global init.defaultBranch main
git config --global credential.helper store

git config --global --list
```

* Download this project

```
git clone https://github.com/xsuntel/symfony-scripts.git symfony

cd symfony && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

* Update default variables and the latest version of Symfony [Releases](https://symfony.com/releases) - [TimeZone](https://www.php.net/manual/en/timezones.php)

```
vi env.app

# >>>> Platform                                                              
PLATFORM_TIMEZONE="{Your TimeZone}"

# >>>> Project
PROJECT_DOMAIN="{Your Web domain}"

# >>>> PHP
SYMFONY_VERSION=7.2.* 
```

* Creating Symfony Applications - [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)

```
./tools/tutorial/symfony.sh
```
 
#### Deployment

* Ubuntu Desktop
  * [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/linux/ubuntu/ABSTRACT.md)

* Macos 
  * [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/macos/device/ABSTRACT.md)

* Windows
  * [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/windows/device/ABSTRACT.md)


### Prod Environment

#### Production

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