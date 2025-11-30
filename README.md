# README

## Abstract

This project includes some shell-scripts for Full-Stack developer to develop a web application using Symfony Framework

* App : PHP - Symfony Framework
* Cache : Redis
* Database : PostgreSQL
* Message : RabbitMQ
* Server : Nginx

## Platform

* Linux
* MacOS
* Windows

## Project

```text
    api/
    app/

        | -- Symfony Framework -- |

    diagram/
        CSP (Cloud Service Provider)/
        VM (Virtual Machine)/
    scripts/
        base/
        console/
        deploy/
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

* Update default variables
  * [TimeZone](https://www.php.net/manual/en/timezones.php)
  * [Symfony Releases](https://symfony.com/releases)

  ```bash
  vi env.app

  # >>>> Platform
  PLATFORM_TIMEZONE="{Your TimeZone}"

  # >>>> Project
  PROJECT_DOMAIN="{Your Web domain}"

  # >>>> PHP
  SYMFONY_VERSION="{Stable Release}"
  ```

#### New Project

* Create a new project

  ```bash
  ./tools/tutorial.sh
  ```

  * Reference : [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)

#### Tools

* AI
  * Antigravity - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/tools/ide/_ANTIGRAVITY.md)
* IDE
  * PhpStorm    - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/tools/ide/_PHPSTORM.md)
  * VSCode      - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/tools/ide/_VSCODE.md)

#### Deployment

* Platform : [Tested Devices](https://github.com/xsuntel/symfony-scripts/wiki)
  * Linux - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/deploy/linux/ubuntu/_ABSTRACT.md)
  * Macos - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/deploy/macos/device/_ABSTRACT.md)
  * Windows - [Document](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/deploy/windows/device/_ABSTRACT.md)

### Prod Environment

#### Production

* Public Cloud
  * AWS (Amazon Web Services)
  * GCP (Google Cloud Platform)
  * NCloud (Naver Cloud Platform)

## Tutorial

* [Symfony Framework](https://symfony.com)
* [SymfonyCasts](https://symfonycasts.com)

## Reference

* Website - [XSUN.AI](https://xsun.ai)

## License

This is available under the MIT License.
