# Scripts

## Prod Environment

### Platform

* Linux - [Ubuntu Server](https://ubuntu.com/download/server/arm)
    * App : PHP
    * Cache : Redis
    * Database : PostgreSQL
    * Message : RabbitMQ
    * Server : Nginx

* Connect Instance in LightSail - [Document](https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-ssh-using-terminal.html)

```
sudo chmod 400 "${KEY_PATH}/{your name}.pem"

ssh -i "${KEY_PATH}/{your name}.pem/${KEY_NAME}" "${USER}@${HOST}"
```

#### Ubuntu

* User

```
sudo cat /etc/passwd

# Login ID : x : UID : GID : Description : Home Directory : Login Shell
```

```
sudo cat /etc/shadow

# Login ID : User Password : Last changed data : MIN : MAX : WARNING : INACTIVE : EXPIRE : Flag
```

* Group

```
sudo cat /etc/group

# Group Name : x : GID : Group Members
```

```
sudo cat /etc/gshadow

# Group Name : Group Password : Administrator : Group Members
```

### Project

* Update default variables

```
vi .env.prod

# ----------------------------------------------------------------------------------------------------------------------
# Software Bundles
# ----------------------------------------------------------------------------------------------------------------------

# >>>> App
LOCAL_URL_HOST=127.0.0.1
LOCAL_URL_PORT=80

# >>>> Cache
REDIS_HOST={Your Host}
REDIS_PORT=6379

# >>>> Database
POSTGRES_HOST={Your Host}
POSTGRES_PORT=5432
POSTGRES_DB={Your default Database}
POSTGRES_USER={Your Name}
POSTGRES_PASSWORD={Your Password}

# >>>> Server
PUBLIC_URL_HOST={Your Domain}
PUBLIC_URL_PORT=443
```

### App

#### Symfony Framework

* Update packages

```
cd ~/Downloads

sudo apt update -y
sudo apt install -y curl git wget unzip
sudo apt autoremove -y
```

* Work Directory

```
sudo mkdir -p /var/www
sudo mkdir -p /var/www/github
sudo chown -R "${LOGNAME}":"${LOGNAME}" /var/www/github

cd /var/www/github && if [ -d symfony ]; then rm -rf symfony ; fi
```

* Download this project

```
git clone https://github.com/xsuntel/symfony-scripts.git symfony

cd symfony && find ./scripts/ -type f -name "*.sh" -exec chmod 775 {} \;
```

* Deploy this project

```
./scripts/cloud/aws/lightsail/deploy.sh
```

### Database

#### PostgreSQL

* Update databases
    * create
    * schema

```
./scripts/tools/ide/migrate.sh
```

## Reference

### Server

* Cloud
    * AWS (Amazon Web Services)
        * [Lightsail](https://aws.amazon.com/ko/lightsail)
