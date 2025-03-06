# Tutorial

## Abstract

This project includes some shell-scripts to develop a web application using Symfony Framework

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

### Download Symfony

* Check default variables and the latest version of Symfony - [Releases](https://symfony.com/releases)

```
vi ./env.app

# >>>> PHP
SYMFONY_VERSION=7.2.*
```

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

* Migrate databases

```
./tools/ide/migrate.sh
```

* Clear cache

```
./tools/ide/update.sh
```

## Reference

### Symfony

* [Symfony](https://symfony.com)
* [SymfonyCasts](https://symfonycasts.com)
