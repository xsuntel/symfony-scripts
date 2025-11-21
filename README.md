# README

## Abstract

This project includes some shell-scripts for Full-Stack developer to develop a web application
using [Symfony Framework](https://symfony.com)

## Platform

* Linux
* MacOS
* Windows

## Project

```text
    app/
    
        | -- Symfony Framework -- |

    diagram/
        cloud/
        compute/
        source/
        tools/
    scripts/
        base/
        console/
        deploy/
        develop/
    tools/
        api/
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

* App : PHP - Symfony Framework
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx

#### Requirement

* Update your name and email for Git

  ```bash
  git config --global user.name "{Your Name}"
  git config --global user.email "{Your Email}"

  git config --global init.defaultBranch main
  git config --global credential.helper store

  git config --global --list
  ```

* Work Directory

  ```bash
  mkdir -p ~/Applications
  mkdir -p ~/Applications/GitHub

  cd ~/Applications/GitHub
  ```

* Download this project

  ```bash
  git clone https://github.com/xsuntel/symfony-scripts.git symfony

  cd symfony && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
  ```

* Update default
  variables - [Symfony Releases](https://symfony.com/releases) - [TimeZone](https://www.php.net/manual/en/timezones.php)

  ```bash
  vi env.app

  # >>>> Platform                                                              
  PLATFORM_TIMEZONE="{Your TimeZone}"

  # >>>> Project
  PROJECT_DOMAIN="{Your Web domain}"

  # >>>> PHP
  SYMFONY_VERSION=7.3.* 
  ```

#### New Project

* Create a new project : [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)

  ```bash
  ./tools/tutorial.sh
  ```

#### Deployment

* Environment
  * Laptop - [Devices](https://github.com/xsuntel/symfony-scripts/wiki)
* Platform
  * Linux - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/develop/linux/ubuntu/ABSTRACT.md)
  * Macos - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/develop/macos/device/ABSTRACT.md)
  *
  Windows - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/develop/windows/device/ABSTRACT.md)

### Prod Environment

#### Production

* Public Cloud
  * AWS (Amazon Web Services)
  * GCP (Google Cloud Platform)
  * NCloud (Naver Cloud Platform)

  ```bash
  ls ./scripts/cloud
  ```

## Tutorial

* [SymfonyCasts](https://symfonycasts.com)

## Reference

* Website - [XSUN.AI](https://xsun.ai)

## License

This is available under the MIT License.
