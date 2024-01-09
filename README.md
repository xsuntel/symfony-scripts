# XSUN

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* This project is for Full-Stack developer 
  * App : PHP
  * Cache : Redis 
  * Database : PostgreSQL 
  * Server : Nginx

## Project

```
    app/
    scripts/
        cloud/
            aws/
                ABSTRACT.md
                deploy.sh
                migrate.sh
                status.sh
        docker/
            containers/
                ABSTRACT.md
                deploy.sh
                migrate.sh
                status.sh
        vm/
            ubuntu/
                ABSTRACT.md
                deploy.sh
                migrate.sh
                status.sh
    tools/
        git/
        ide/
        webbrowser/
    tutorial/
        symfony/
            create.sh
    .env
    .env.dev
    .env.dev.local
    .gitignore
    docker-compose.dev.env
    docker-compose.dev.yml
    docker-compose.yml
    LICENSE
    README.md
```

### App

* PHP Framework - [Symfony](https://symfony.com)

### Scripts

* Cloud
  * Amazon Web Services - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/master/scripts/cloud/aws/ABSTRACT.md)
* Docker
  * Containers          - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/master/scripts/docker/containers/ABSTRACT.md)
* VM
  * Ubuntu 22.04.3 LTS  - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/master/scripts/vm/ubuntu/ABSTRACT.md)

### Tools

* Git
    * GitHub - [Wiki](https://github.com/xsuntel/symfony-scripts/wiki)
* IDE
    * PhpStorm - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/master/tools/ide/phpstorm/ABSTRACT.md)
* Web browser
    * Firefox - [Environment](https://github.com/xsuntel/symfony-scripts/blob/master/tools/webbrowser/firefox/ABSTRACT.md)

### Tutorial

* [Symfony](https://symfony.com/releases)
```
[user@localhost] git clone https://github.com/xsuntel/symfony-scripts.git symfony 
```

```
[user@localhost] cd ./symfony
[user@localhost] vi ./env
# >>>> PHP
PHP_FRAMEWORK_VERSION=6.4
```

```
[user@localhost] ./tutorial/symfony/create.sh
```

## Reference

* App
  * PHP
    * Design Patterns - [Manual](https://designpatternsphp.readthedocs.io/en/latest/)
    * PHPUnit - [Manual](https://docs.phpunit.de/en/9.6/index.html#)
    * XDebug - [Manual](https://xdebug.org)
  * Symfony
    * [SymfonyCasts](https://symfonycasts.com)
* Tools
  * UML
    * StarUML - [Download](https://staruml.io/)

## License
This is available under the MIT License.
Created by [Ryan Lim](https://github.com/xsuntel),
