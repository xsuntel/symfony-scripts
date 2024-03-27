# Tutorial

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* App (PHP) + Cache (Redis) + Database (PostgreSQL) + Server (Nginx)

## Dev Environment

### Platform

#### Linux

* Work Directory

```
[user@localhost] sudo mkdir -p /var/www
[user@localhost] sudo mkdir -p /var/www/github
[user@localhost] sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github
[user@localhost] cd /var/www/github
```

#### MacOS

* Work Directory

```
[user@localhost] mkdir -p ~/Applications
[user@localhost] mkdir -p ~/Applications/PhpStorm
[user@localhost] mkdir -p ~/Applications/PhpStorm/github
[user@localhost] ~/Applications/PhpStorm/github
```

#### Windows

* Work Directory

```
[user@localhost] mkdir -p ~/Applications
[user@localhost] mkdir -p ~/Applications/PhpStorm
[user@localhost] mkdir -p ~/Applications/PhpStorm/github
[user@localhost] ~/Applications/PhpStorm/github
```

### App

* Git

```
[user@localhost] git clone https://github.com/xsuntel/symfony-scripts.git symfony

[user@localhost] cd symfony
[user@localhost] find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

* Symfony - [Installing & Setting up the Symfony Framework](https://symfony.com/doc/current/setup.html)
  * Please check the latest version from the website - [Releases](https://symfony.com/releases)

```
[user@localhost] vi ./env
# >>>> PHP
PHP_FRAMEWORK_VERSION=7.0.*

[user@localhost] ./tutorial/symfony/create.sh
```

## Reference

### Tools

* Git
  * [GitHub](https://github.com)
