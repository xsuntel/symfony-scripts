# XSUN

eXtremely & Sensationally United Networks

## Abstract

This project includes some shell-scripts for Full-Stack developer to develop a web application using Symfony Framework

  * App : PHP
  * Cache : Redis 
  * Database : PostgreSQL 
  * Server : Nginx

## Project

```
    app/
        assets/
        bin/
        config/
        public/
        src/
        templates/
        translations/
        tests/
        var/
        vendor/
        .env
        composer.json
        package.json
    scripts/
        base/
        cloud/
        docker/
        linux/
        macos/
        windows/
    tools/
        git/
        ide/
        webbrowser/
    tutorial/
        symfony/
    .env
    .env.dev
    .env.dev.local
    .env.prod
    .env.prod.local
    .gitignore
    .symfony.local.yaml
    LICENSE
    README.md
```

### App

* PHP : [Symfony Framework](https://symfony.com)

### Scripts

#### Deployment

* Cloud
  * Amazon Web Services - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/cloud/aws/Abstract.md)
  * Google
  * Microsoft 
  * Naver
* Docker
  * Containers          - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/docker/containers/Abstract.md)
* Linux
  * Amazon Linux        - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/linux/amazonlinux/Abstract.md)
  * CentOS              - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/linux/centos/Abstract.md)
  * Ubuntu              - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/linux/ubuntu/Abstract.md) 
* Macos
  * Desktop             - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/macos/desktop/Abstract.md)
* Windows
  * Desktop             - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/scripts/windows/desktop/Abstract.md)

#### Development

* Migrate the related databases

```
[user@localhost] ./scripts/containers/migrate.sh
```

* Check status of the system

```
[user@localhost] ./scripts/containers/status.sh
```

* Troubleshoot issues and Debugging it

```
[user@localhost] ./scripts/containers/update.sh
```

### Tools

* Git
    * GitHub            - [Wiki](https://github.com/xsuntel/symfony-scripts/wiki)
* IDE
    * PhpStorm          - [Deployment](https://github.com/xsuntel/symfony-scripts/blob/main/tools/ide/phpstorm/Abstract.md)
* Web browser
    * Firefox           - [Environment](https://github.com/xsuntel/symfony-scripts/blob/main/tools/webbrowser/firefox/Abstract.md)

### Tutorial

* Symfony               - [Installing & Setting up the Symfony Framework](https://github.com/xsuntel/symfony-scripts/blob/main/tutorial/symfony/Abstract.md)

## Reference

* App
  * PHP
    * Design Patterns   - [Manual](https://designpatternsphp.readthedocs.io/en/latest/)
    * PHPUnit           - [Manual](https://docs.phpunit.de/en/9.6/index.html#)
    * XDebug            - [Manual](https://xdebug.org)
  * Symfony             - [Documents](https://symfony.com)
    * [SymfonyCasts](https://symfonycasts.com)
  * Themes
    * Flowbite          - [Download](https://flowbite.com/)

* Tools
  * Git
    * GitHub            - [Download](https://github.com)
  * IDE
    * PhpStorm          - [Download](https://www.jetbrains.com/phpstorm)
  * Web Browser
    * Firefox           - [Download](https://www.mozilla.org)

## License
This is available under the MIT License.
