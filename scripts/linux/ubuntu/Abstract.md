# Ubuntu

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

* Linux - Ubuntu Desktop (Parallels, VMware)

    * Install required packages

```
[user@localhost] cd ~/Downloads
[user@localhost] sudo apt update -y
[user@localhost] sudo apt install -y curl git wget unzip
[user@localhost] sudo apt autoremove -y
```

### App

#### 1) Create a new directory

* Work Directory

```
[user@localhost] sudo mkdir -p /var/www
[user@localhost] sudo mkdir -p /var/www/github
[user@localhost] sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github
```

#### 2) Download this project

* Git

```
[user@localhost] cd /var/www/github
[user@localhost] git clone https://github.com/xsuntel/symfony-scripts.git symfony

[user@localhost] cd symfony
[user@localhost] find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

#### 3) Deploy this project

* Deploy this project

```
[user@localhost] ./scripts/linux/ubuntu/deploy.sh
```

## Reference

### Server
* [Ubuntu Desktop](https://ubuntu.com/desktop)
