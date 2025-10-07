# Symfony Scripts

## Abstract

This project includes some shell-scripts for Full-Stack developer to develop a web application
using [Symfony Framework](https://symfony.com)

## Platform

* Linux
* MacOS
* Windows

## Project

### Directories

```
    app/
    
        | -- Symfony Framework -- |

    console/
    diagrams/
    scripts/
        base/
        cloud/
        docker/
        linux/
        macos/
        windows/
    tools/
        ai/
        git/
        ide/
        .symfony.local.yaml
        tutorial.sh
    .env.app
    .env.dev
    .env.dev.local
    .env.prod
    .env.prod.local
    .gitignore
    LICENSE
    README.md
```

### Dev Environment

* App : PHP
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx

#### Requirement

* Update your name and email for Git

  ```
  git config --global user.name "{Your Name}"
  git config --global user.email "{Your Email}"

  git config --global init.defaultBranch main
  git config --global credential.helper store

  git config --global --list
  ```

* Work Directory

  ```
  mkdir -p ~/Applications
  mkdir -p ~/Applications/GitHub

  cd ~/Applications/GitHub
  ```

* Download this project

  ```
  git clone https://github.com/xsuntel/symfony-scripts.git symfony

  cd symfony && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
  ```

* Update default
  variables - [Symfony Releases](https://symfony.com/releases) - [TimeZone](https://www.php.net/manual/en/timezones.php)

  ```
  vi env.app

  # >>>> Platform                                                              
  PLATFORM_TIMEZONE="{Your TimeZone}"

  # >>>> Project
  PROJECT_DOMAIN="{Your Web domain}"

  # >>>> PHP
  SYMFONY_VERSION=7.3.* 
  ```

#### New Project

* Create a new project - [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)

  ```
  ./tools/tutorial.sh
  ```
 
#### Deployment

* Linux - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/linux/ubuntu/ABSTRACT.md) on Ubuntu
  Desktop
* Macos - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/macos/device/ABSTRACT.md)
* Windows - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/windows/device/ABSTRACT.md)

### Prod Environment

#### Production

* Public Cloud
  * AWS (Amazon Web Services)
    * Elastic Beanstalk   - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/elasticbeanstalk/ABSTRACT.md)
    * Lightsail           - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/lightsail/ABSTRACT.md)

## Tutorial

* [Symfony Framework](https://symfony.com)
* [SymfonyCasts](https://symfonycasts.com)

## Reference

* Dev Environment
  * [Devices](https://github.com/xsuntel/symfony-scripts/wiki)

## License
This is available under the MIT License.