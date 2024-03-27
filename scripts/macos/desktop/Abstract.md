# MacOS

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* App (PHP) + Cache (Redis) + Database (PostgreSQL) + Server (Nginx)

## Dev Environment

* VM
    - Core   : 6
    - Memory : 6 GB
    - Swap   : 2 GB
    - Disk   : 128 GB

### Platform

* MacOS - App (PHP) + Docker (PostgreSQL)

### App

#### 1) Create a new directory

* Work Directory

```
[user@localhost] mkdir -p /Users/$USER/Applications
[user@localhost] mkdir -p /Users/$USER/Applications/PhpStorm/github

```

#### 2) Download this project

* Git

```
[user@localhost] cd /Users/$USER/Applications/PhpStorm/github
[user@localhost] git clone https://github.com/xsuntel/symfony-scripts.git symfony

[user@localhost] cd symfony
[user@localhost] find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

#### 3) Deploy this project

* Deploy this project

```
[user@localhost] ./scripts/macos/desktop/deploy.sh
```

## Reference

### Server
* [MacOS](https://www.apple.com/kr/macos)
