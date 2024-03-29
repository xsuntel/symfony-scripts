# AWS (Amazon Web Services)

This project includes some shell-scripts to develop a web application using Symfony Framework

## Abstract

* App (PHP) + Cache (Redis) + Database (PostgreSQL) + Server (Nginx)

## Prod Environment

* VM
    - Core   : 6
    - Memory : 6 GB
    - Swap   : 2 GB
    - Disk   : 128 GB

### Platform

* Lightsail - [Ubuntu Server](https://ubuntu.com/download/server/arm)

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

#### 3) Deploy this application

* Deploy this project

```
[user@localhost] ./scripts/cloud/aws/deploy.sh
```

#### 4) SSH Client

* Connect Instance

```
[user@localhost] sudo chmod 400 LightsailDefaultKey-ap-northeast-2.pem
[user@localhost] ssh -i LightsailDefaultKey-ap-northeast-2.pem ubuntu@ipaddress
```

* Upload a file

```
[user@localhost] scp -i ~/Documents/LightsailDefaultKey-ap-northeast-2.pem file_name.zip ubuntu@xxx.xxx.xxx.xxx:/home/ubuntu

[user@localhost] ssh -i ~/Documents/LightsailDefaultKey-ap-northeast-2.pem file_name.zip ubuntu@xxx.xxx.xxx.xxx

[user@localhost] rm -Rf /var/www/github/symfony
[user@localhost] unzip file_name.zip -d /var/www/github

[user@localhost] cd /var/www/github/symfony
[user@localhost] find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;

[user@localhost] ./scripts/cloud/aws/deploy.sh 
```

## Reference

### Server

* Cloud
    * AWS (Amazon Web Services)
        * [Lightsail](https://aws.amazon.com/ko/lightsail)
        * [Elastic Beanstalk](https://aws.amazon.com/ko/elasticbeanstalk)
