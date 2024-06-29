# IDE - PhpStorm, VSCode

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* App (PHP) + Cache (Redis) + Database (PostgreSQL) + Server (Nginx)

## Dev Environment

### Platform

* Linux
* MacOS
* Windows

### Project - Settings

#### Development

* Check something in Dev Environment

```
./tools/ide/check.sh
```

* Migrate databases in Dev Environment

```
./tools/ide/migrate.sh
```

* Update some sources and Debugging it in Dev Environment

```
./tools/ide/update.sh
```

## Reference

### Tools

* IDE
  * [PhpStorm](https://www.jetbrains.com/phpstorm)
    * Settings
      * PHP
        * Xdebug - [Configuration](https://www.jetbrains.com/help/phpstorm/debugging-with-phpstorm-ultimate-guide.html)
      * Deployment - [Deploying application](https://www.jetbrains.com/help/phpstorm/deploying-applications.html)
      * Symfony - [Symfony Framework](https://www.jetbrains.com/help/phpstorm/symfony-support.html#use_symfony_cli)